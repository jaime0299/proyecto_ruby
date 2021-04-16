require_relative 'database'
require 'fox16'
include Fox  

class Administrador < FXMainWindow  
  def initialize(app,name,user,tipo) 
    @dataB = DatabaseSchool.new()  
    @app = app
    super(app, tipo.upcase, :width => 910, :height => 500, :padding => 10) 

    #print "Hi, Welcome to General administrator, #{user}"910 
    
    groupbox = FXGroupBox.new(self, "",:opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fuente = FXFont.new(app,"Time New Roman, 120, BOLD,0")
    welcome_to_admi = FXLabel.new(groupbox,"Hi, Welcome to General administrator, #{name}",
      :opts=>LAYOUT_EXPLICIT, :width=>875, :height=>20, :x=>7, :y=>10)
    welcome_to_admi.textColor = FXRGB(0, 0, 255)
    welcome_to_admi.font = fuente

    #ADD NEW USER
    tx1 = FXLabel.new(groupbox, "Add New User",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>250, :height=>23, :x=>7, :y=>50)
    #. 

    tx2 = FXLabel.new(groupbox, "Name:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>7, :y=>90)
    nameTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>197, :height=>20, :x=>60, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    tx2 = FXLabel.new(groupbox, "User:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>7, :y=>115)
    userTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>197, :height=>20, :x=>60, :y=>115)
    tx2.textColor = FXRGB(255, 0, 0)

    tx2 = FXLabel.new(groupbox, "Password:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>7, :y=>140)
    passTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>197, :height=>20, :x=>60, :y=>140)
    tx2.textColor = FXRGB(255, 0, 0)

    tx2 = FXLabel.new(groupbox, "Type User:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>7, :y=>165) 
    typeuser = FXComboBox.new(groupbox, 20,:opts => COMBOBOX_NO_REPLACE|LAYOUT_EXPLICIT|FRAME_GROOVE|FRAME_THICK,
      :width=>197, :height=>20, :x=>60, :y=>165)

    typeuser.numVisible = 3
    typeuser.editable = false
    typeuser.appendItem("Option")
    typeuser.appendItem("Teacher")
    typeuser.appendItem("Student")
    typeuser.appendItem("Administrator")

    typeuser.connect(SEL_COMMAND) do |sender, sel, data|
      print "materia: ",sender.text,".\n"
    end

    tx2.textColor = FXRGB(255, 0, 0)

    #BUTTON ADD
    add_user_Button = FXButton.new(groupbox, "ADD USER",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>197, :height=>20, :x=>60, :y=>200) 
    add_user_Button.connect(SEL_COMMAND) do
      userText=userTextField.text
      nameText=nameTextField.text
      passText=passTextField.text
      typeText=typeuser.text
      if userText!="" && nameText!="" && passText!="" && typeText!="Option"
        res=@dataB.insertarUser(userText,nameText,passText,typeText)
        if res==true
          FXMessageBox.information(@app, MBOX_OK, "Add user", "User added succesfully")
          @tabla.clearItems()
          llena_datos()
          @teacher.clearItems()
          maestros = @dataB.selectUsers('Teacher')
          len = maestros.length
          for i in 0...len do
            row=maestros[i]
            @teacher.appendItem(row[:name])
          end
        else
          FXMessageBox.error(@app, MBOX_OK, "Add user", "There was an error, check your data")
        end
      else
        FXMessageBox.error(@app, MBOX_OK, "Add user", "Please fill all the inputs")
      end
    end 
    #.

    #ADD NEW CLASS
    tx1 = FXLabel.new(groupbox, "Add New Class",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>250, :height=>23, :x=>270, :y=>50)
    #. 
    
    tx2 = FXLabel.new(groupbox, "Name:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>270, :y=>90)
    nameClassTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>200, :height=>20, :x=>320, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    #BUTTON ADD CLASS
    add_class_Button = FXButton.new(groupbox, "ADD CLASS",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>197, :height=>20, :x=>320, :y=>120)
    add_class_Button.connect(SEL_COMMAND) do
      nameClass=nameClassTextField.text
      if nameClass!=""
        res = @dataB.agregarMateria(nameClass)
        if res==true
          FXMessageBox.information(@app, MBOX_OK, "Add class", "Class added succesfully")
          @assclass.clearItems()
          res = @dataB.getMaterias()
          len=res.length
          for i in 0...len do
            row=res[i]
            @assclass.appendItem(row[0])
          end 
        else
          FXMessageBox.error(@app, MBOX_OK, "Add class", "There was an error, check your data")
        end
      else
        FXMessageBox.error(@app, MBOX_OK, "Add class", "Please type a class name")
      end
    end
    #.

    #Assign Class
    tx1 = FXLabel.new(groupbox, "Assign a Class to a Teacher",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>350, :height=>23, :x=>533, :y=>50)
    #.

    tx2 = FXLabel.new(groupbox, "Teacher",:opts=>LAYOUT_EXPLICIT,
      :width=>150, :height=>23, :x=>533, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    #BUTTON ASSIGN
    teacher_sel = ""
    class_sel = ""
    assing_Button = FXButton.new(groupbox, "ASSIGN",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>70, :height=>20, :x=>813, :y=>200)
    assing_Button.connect(SEL_COMMAND) do
      if teacher_sel!="" && class_sel!=""
        res = @dataB.asignaciones(teacher_sel,class_sel)
        if res==true
          FXMessageBox.information(@app, MBOX_OK, "Assign class", "Class assigned succesfully")
        else
          FXMessageBox.error(@app, MBOX_OK, "Assign class", "There was an error, check your data")
        end
      else
        FXMessageBox.error(@app, MBOX_OK, "Assign class", "Please select a teacher and a class")
      end
    end
    #.

    @teacher = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
      :width=>150, :height=>75, :x=>533, :y=>115)
    maestros = @dataB.selectUsers('Teacher')
    len = maestros.length
    for i in 0...len do
      row=maestros[i]
      @teacher.appendItem(row[:name])
    end
    
    lA = []
    lT = []    
    asignacion = ""
    val_teacher = ""
    @teacher.connect(SEL_COMMAND) do
      lA = []
      lT = [] 
      selected_items = []      
      @teacher.each { |item| selected_items << item if item.selected? }
      unless selected_items.empty?
        asignacion = ""
        teacher_text = ""
        selected_items.each do |item|
          teacher_text += ", " unless teacher_text.empty?
          teacher_text += item.text
          teacher_sel = item.text
          asignacion += teacher_text
          val_teacher = teacher_text
          if (!lT.include?(item.text))
            lT.push(item.text)
          end
        end
        #assign_class.text = asignacion + " --> "
        puts lT
      else
        puts "No items selected"
      end
    end

    tx2 = FXLabel.new(groupbox, "Class",:opts=>LAYOUT_EXPLICIT,
      :width=>150, :height=>23, :x=>733, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    @assclass = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
      :width=>150, :height=>75, :x=>733, :y=>115)
    res = @dataB.getMaterias()
    len=res.length
    for i in 0...len do
      row=res[i]
      @assclass.appendItem(row[0])
    end    
    
    val_class = ""
    lClass = [] 
    @assclass.connect(SEL_COMMAND) do
      lClass = [] 
      selected_items = []
      @assclass.each { |item| selected_items << item if item.selected? }
      unless selected_items.empty?
        asignacion = "#{val_teacher} --> "
        class_text = ""
        selected_items.each do |item|
          class_text += ", " unless class_text.empty?
          class_text += item.text
          class_sel = item.text
          asignacion += class_text
          val_class = class_text
          if(!lClass.include?(item.text))
            lClass.push(item.text)
          end
        end
        #assign_class.text = asignacion + "."
        #puts lClass
        if(!lT.empty? && !lClass.empty?)
          linea = textArea_Teacher(lT,lClass)
          @textArea1.text = ""
          @textArea1.text = linea
        else
          print "No items selected"
        end        
      else
        puts "No items selected"
      end
    end   

    #Assing
    tx1 = FXLabel.new(groupbox, "Assigns",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>350, :height=>23, :x=>533, :y=>240)
    #.

    @textArea1 = FXText.new(groupbox, :opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>350, :height=>162, :x=> 533, :y=>280)
    @textArea1.editable = false

    #Registered users
    tx1 = FXLabel.new(groupbox, "Registered Users",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>510, :height=>23, :x=>7, :y=>240)
    #. 

    @tabla = FXTable.new(groupbox, :opts => LAYOUT_EXPLICIT | TABLE_NO_COLSELECT,
      :width=>501, :height=>162, :x=>12, :y=>280)
    @tabla.setTableSize(15, 6)

    @tabla.rowHeaderMode = LAYOUT_FIX_WIDTH
    @tabla.rowHeaderWidth = 0

    @tabla.editable = false
    @tabla.setColumnText(0, "Name")
    @tabla.setColumnText(1, "User")
    @tabla.setColumnText(2, "User type")
    @tabla.setColumnText(3, "Password")
    @tabla.setColumnText(4, "Action")

    usuarios = @dataB.selectAllUsers()
    len=usuarios.length
    for i in 0...len do
      row=usuarios[i]
      @tabla.setItemText(i,0, row[1])
      @tabla.setItemText(i,1, row[0])
      @tabla.setItemText(i,2, row[3])
      @tabla.setItemText(i,3, row[2])
      @tabla.setItemText(i,4, "ELIMINAR")
    end

    @tabla.connect(SEL_COMMAND) do |sender, sel, data|
        if (sender.anchorColumn == 4)

            nameDel = @tabla.getItem(sender.anchorRow,0).to_s
            userDel = @tabla.getItem(sender.anchorRow,1).to_s
            typeDel = @tabla.getItem(sender.anchorRow,2).to_s
            if typeDel!="Administrator"
              res = @dataB.deleteUser(userDel,nameDel,typeDel)
              if res
                FXMessageBox.information(@app, MBOX_OK, "Delete user", "User deleted succesfully")
                @tabla.clearItems()
                llena_datos()
                @teacher.clearItems()
                maestros = @dataB.selectUsers('Teacher')
                len = maestros.length
                for i in 0...len do
                  row=maestros[i]
                  @teacher.appendItem(row[:name])
                end
              else
                FXMessageBox.error(@app, MBOX_OK, "Delete user", "There was an error, sorry :(")
              end
            else
              FXMessageBox.error(@app, MBOX_OK, "Delete user", "It is forbidden to delete an Admin")
            end

            #puts table.getItem(sender.anchorRow,sender.anchorColumn)
            #puts "anchor row, col = #{sender.anchorRow}, #{sender.anchorColumn}"
        end
    end

    #BUTTON CLOSE
    close_Button = FXButton.new(groupbox, "CLOSE",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>100, :height=>20, :x=>785, :y=>450)
    close_Button.connect(SEL_COMMAND) do
      require_relative './Login.rb'
      mainWindow1 = Login.new(@app)
      mainWindow1.create
      mainWindow1.show
      self.close()
    end
    
  end

  def llena_datos()
    @tabla.setTableSize(15, 6)
    @tabla.setColumnText(0, "Name")
    @tabla.setColumnText(1, "User")
    @tabla.setColumnText(2, "User type")
    @tabla.setColumnText(3, "Password")
    @tabla.setColumnText(4, "Action")

    usuarios = @dataB.selectAllUsers()
    len=usuarios.length
    for i in 0...len do
      row=usuarios[i]
      @tabla.setItemText(i,0, row[1])
      @tabla.setItemText(i,1, row[0])
      @tabla.setItemText(i,2, row[3])
      @tabla.setItemText(i,3, row[2])
      @tabla.setItemText(i,4, "ELIMINAR")
    end
  end

  def textArea_Teacher(lista1,lista2)
    linea = ""
    for i in 0...lista1.length
        mate = ""
        if (lista2.length == 1)
            mate = lista2[0]
        else                
            for j in 0...lista2.length
                if (j < lista2.length-1)
                    mate += "#{lista2[j]}, "
                else
                    mate += lista2[j]
                end
            end
        end
        linea += "Alumno: #{lista1[i]} \nMaterias: #{mate}.\n\n"
    end
    return linea
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end  

#app = FXApp.new  
#Administrador.new(app,"Adain Magallenes", "Guille","Administrador General")  
#app.create  
#app.run