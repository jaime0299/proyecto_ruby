require_relative 'database' 
require 'fox16'
include Fox 

class Maestro < FXMainWindow  
  def initialize(app,name,user,tipo)  
    @dataB = DatabaseSchool.new() 
    @app = app
    @teacher_set = name
    super(app, tipo.upcase, :width => 915, :height => 500, :padding => 10) 

    #print "Hi, Welcome to Teacher, #{user}" 
    
    groupbox = FXGroupBox.new(self, "",:opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fuente = FXFont.new(app,"Time New Roman, 120, BOLD,0")
    welcome_to_admi = FXLabel.new(groupbox,"Hi, Welcome to teacher, #{name}",
      :opts=>LAYOUT_EXPLICIT, :width=>875, :height=>20, :x=>7, :y=>10)
    welcome_to_admi.textColor = FXRGB(0, 0, 255)
    welcome_to_admi.font = fuente

    #INFO Teacher
    tx1 = FXLabel.new(groupbox, "Info Teacher",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>250, :height=>23, :x=>7, :y=>50)
    #. 

    tx2 = FXLabel.new(groupbox, "Name:",:opts=>LAYOUT_EXPLICIT,
        :width=>50, :height=>20, :x=>7, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)    
    nameTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>197, :height=>20, :x=>60, :y=>90)
    nameTextField.text = name
    nameTextField.editable = false

    tx2 = FXLabel.new(groupbox, "User:",:opts=>LAYOUT_EXPLICIT, 
        :width=>50, :height=>20, :x=>7, :y=>115)
    tx2.textColor = FXRGB(255, 0, 0)    
    userTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>197, :height=>20, :x=>60, :y=>115)
    userTextField.text = user
    userTextField.editable = false

    tx2 = FXLabel.new(groupbox, "Type User:",:opts=>LAYOUT_EXPLICIT, 
        :width=>50, :height=>20, :x=>7, :y=>140)
    tx2.textColor = FXRGB(255, 0, 0)
    typeuser = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>197, :height=>20, :x=>60, :y=>140)
    typeuser.text = tipo
    typeuser.editable = false

    #Assign Class
    student_set=""
    class_set=""
    tx1 = FXLabel.new(groupbox, "Add a Student to a Class",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>350, :height=>23, :x=>270, :y=>50)
    #.
      
    tx2 = FXLabel.new(groupbox, "Student",:opts=>LAYOUT_EXPLICIT,
        :width=>150, :height=>23, :x=>270, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    student = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
        :width=>150, :height=>75, :x=>270, :y=>115)
    alumnos = @dataB.selectUsers('Student')
    len=alumnos.length
    for i in 0...len do
        row=alumnos[i]
        student.appendItem(row[:name])
    end

    lM = []
    lS = []
    add = ""
    val_student = ""
    student.connect(SEL_COMMAND) do
      lM = []
      lS = []
      selected_items = []
      student.each { |item| selected_items << item if item.selected? }
      unless selected_items.empty?
        add = ""
        student_text = ""
        selected_items.each do |item|
          student_text += ", " unless student_text.empty?
          student_text += item.text
          student_set = item.text
          add += student_text
          val_student = student_text
          if (!lS.include?(item.text))
            lS.push(item.text)
          end
        end        
        #puts "Es: #{val_student}"
        #puts "L: #{lS}\n"
        #assign_class.text = add + " --> "
      else
        puts "No items selected"
      end
    end

    tx2 = FXLabel.new(groupbox, "Class",:opts=>LAYOUT_EXPLICIT,
    :width=>150, :height=>23, :x=>470, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    assclass = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
        :width=>150, :height=>75, :x=>470, :y=>115)
    
    maestros = @dataB.getMateriasM(@teacher_set)
    len = maestros.length
    for i in 0...len do
        row=maestros[i]
        assclass.appendItem(row[:class])
    end   
    
    lC = []
    val_class = ""
    assclass.connect(SEL_COMMAND) do
        selected_items = []
        lC = []
        assclass.each { |item| selected_items << item if item.selected? }
        unless selected_items.empty?
            add = "#{val_student} --> "
            class_text = ""
            selected_items.each do |item|
                class_text += ", " unless class_text.empty?
                class_text += item.text
                class_set = item.text
                add += class_text
                val_class = class_text
                if (!lC.include?(item.text))
                    lC.push(item.text)
                end
            end
            if (lS && lC)
                linea = textArea_Student(lS,lC)
                @textArea.text = ""
                @textArea.text = linea
            else
                puts "No items selected"
            end
            #puts "ES: #{val_class}"
            #assign_class.text = add + "."
        else
            puts "No items selected"
        end
    end

    #ASSIGN BUTTON
    ass_Button = FXButton.new(groupbox, "Enroll",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
        :width=>100, :height=>20, :x=>642, :y=>200)
    ass_Button.connect(SEL_COMMAND) do
        if student_set!="" && class_set!=""
            res = @dataB.enrollStudent(class_set,student_set)
            if res
                FXMessageBox.information(@app, MBOX_OK, "Enroll", "Student enrolled succesfully")
                @tabla.clearItems()
                llena_datos()
            else
                FXMessageBox.error(@app, MBOX_OK, "Enroll", "It is possible that this student was already enrolled for this class")
            end
        else
            FXMessageBox.error(@app, MBOX_OK, "Assign class", "Please select a student and a class")
        end
    end

    #Registered
    tx1 = FXLabel.new(groupbox, "Registered",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>250, :height=>23, :x=>633, :y=>50)
    #. 

    @textArea = FXText.new(groupbox, :opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>250, :height=>102, :x=> 633, :y=>90)
    @textArea.editable = false

    #Registered students
    tx1 = FXLabel.new(groupbox, "Registered Students",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>301, :height=>23, :x=>7, :y=>200)
    #.

    @tabla = FXTable.new(groupbox, :opts => LAYOUT_EXPLICIT | TABLE_NO_COLSELECT,
        :width=>301, :height=>202, :x=>7, :y=>240)
    @tabla.setTableSize(15, 3)

    @tabla.rowHeaderMode = LAYOUT_FIX_WIDTH
    @tabla.rowHeaderWidth = 0

    @tabla.editable = false
    @tabla.setColumnText(0, "Student")
    @tabla.setColumnText(1, "Class")
    @tabla.setColumnText(2, "Qualification")
    
    alumnos_list = @dataB.getAlumnos(@teacher_set)
    len = alumnos_list.length
    for i in 0...len do
        row=alumnos_list[i]
        @tabla.setItemText(i,0, row[:name])
        @tabla.setItemText(i,1, row[:class])
        @tabla.setItemText(i,2, row[:cal].to_s)
    end

    #Qualification to Student
    tx1 = FXLabel.new(groupbox, "Qualification to Student",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>250, :height=>23, :x=>320, :y=>200)
    #. 

    tx2 = FXLabel.new(groupbox, "Name:",:opts=>LAYOUT_EXPLICIT,
        :width=>50, :height=>20, :x=>320, :y=>240)
    tx2.textColor = FXRGB(255, 0, 0)    
    nameTextField1 = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>197, :height=>20, :x=>373, :y=>240)
    nameTextField1.editable = false

    tx2 = FXLabel.new(groupbox, "Class:",:opts=>LAYOUT_EXPLICIT, 
        :width=>50, :height=>20, :x=>320, :y=>265)
    tx2.textColor = FXRGB(255, 0, 0)    
    classTextField1 = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>197, :height=>20, :x=>373, :y=>265)
    classTextField1.editable = false

    tx2 = FXLabel.new(groupbox, "Qualification:",:opts=>LAYOUT_EXPLICIT, 
        :width=>70, :height=>20, :x=>320, :y=>290)
    tx2.textColor = FXRGB(255, 0, 0)    
    qualiTextField1 = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
        :width=>176, :height=>20, :x=>395, :y=>290)
    qualiTextField1.editable = false
    
    #BUTTON QUALIFY
    qualify_Button = FXButton.new(groupbox, "QUALIFY",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
        :width=>197, :height=>20, :x=>373, :y=>320)
    qualify_Button.connect(SEL_COMMAND) do
        grade = qualiTextField1.text
        alumno = nameTextField1.text
        materia = classTextField1.text
        if grade!=""
            grade = grade.to_i
            if grade.is_a?(Integer)
                if grade>=0 && grade<=100
                    res = @dataB.capturaCalificaciones(alumno,materia,grade)
                    if res
                        FXMessageBox.information(@app, MBOX_OK, "Set grade", "Grade captured succesfully")
                        @tabla.clearItems()
                        llena_datos()
                    else
                        FXMessageBox.error(@app, MBOX_OK, "Set grade", "There was an error")
                    end
                else
                    FXMessageBox.error(@app, MBOX_OK, "Set grade", "Please type a number between 0 and 100")
                end
            else
                FXMessageBox.error(@app, MBOX_OK, "Set grade", "Please type a valid number")
            end
        else
            FXMessageBox.error(@app, MBOX_OK, "Set grade", "Please type a grade")
        end
    end
    #.

    @tabla.connect(SEL_COMMAND) do |sender, sel, data|
        if (sender.anchorColumn == 0)

            nameTextField1.text = @tabla.getItem(sender.anchorRow,0).to_s
            classTextField1.text = @tabla.getItem(sender.anchorRow,1).to_s
            qualiTextField1.text = @tabla.getItem(sender.anchorRow,2).to_s
            qualiTextField1.editable = true

            #puts table.getItem(sender.anchorRow,sender.anchorColumn)
            #puts "anchor row, col = #{sender.anchorRow}, #{sender.anchorColumn}"
        end
    end
    
    #BUTTON CLOSE
    close_Button = FXButton.new(groupbox, "CLOSE",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
        :width=>100, :height=>20, :x=>782, :y=>200)
    close_Button.connect(SEL_COMMAND) do
        require_relative './Login.rb'
        mainWindow1 = Login.new(@app)
        mainWindow1.create
        mainWindow1.show
        self.close()
    end
    
  end

  def llena_datos()
    @tabla.setTableSize(15, 3)
    @tabla.setColumnText(0, "Student")
    @tabla.setColumnText(1, "Class")
    @tabla.setColumnText(2, "Qualification")

    alumnos_list = @dataB.getAlumnos(@teacher_set)
    len = alumnos_list.length
    for i in 0...len do
        row=alumnos_list[i]
        @tabla.setItemText(i,0, row[:name])
        @tabla.setItemText(i,1, row[:class])
        @tabla.setItemText(i,2, row[:cal].to_s)
    end
  end

  def textArea_Student(lista1,lista2)
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
#Maestro.new(app,"Adain Magallenes", "Guille","Maestro")  
#app.create  
#app.run