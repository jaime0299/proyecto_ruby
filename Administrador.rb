require 'fox16'
include Fox  
class Administrador < FXMainWindow  
  def initialize(app,name,user,tipo)  
    @app = app
    super(app, tipo.upcase, :width => 910, :height => 500, :padding => 10) 

    #print "Hi, Welcome to General administrator, #{user}" 
    
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
    typeuser.appendItem("General Administrator")

    typeuser.connect(SEL_COMMAND) do |sender, sel, data|
      print "materia: ",sender.text,".\n"
    end

    tx2.textColor = FXRGB(255, 0, 0)

    #BUTTON ADD
    add_user_Button = FXButton.new(groupbox, "ADD USER",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>197, :height=>20, :x=>60, :y=>200)  
    #.
    
    #Assign Class
    tx1 = FXLabel.new(groupbox, "Assign a Class to a Teacher",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>350, :height=>23, :x=>270, :y=>50)

    tx2 = FXLabel.new(groupbox, "Teacher",:opts=>LAYOUT_EXPLICIT,
      :width=>150, :height=>23, :x=>270, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    assign_class = FXTextField.new(groupbox, 20, :opts => LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>350, :height=>20, :x=>270, :y=>200)
    assign_class.editable = false

    teacher = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
      :width=>150, :height=>75, :x=>270, :y=>115)
    teacher.appendItem("Estrellita")
    teacher.appendItem("Campa")
    teacher.appendItem("Erique")
    teacher.appendItem("Ruben")

    asignacion = "Asiganación del maestro, (TEACHER) a la materia (CLASS)."
    val_teacher = ""
    teacher.connect(SEL_COMMAND) do
      selected_items = []
      teacher.each { |item| selected_items << item if item.selected? }
      unless selected_items.empty?
        asignacion = "Asiganación del maestro, "
        teacher_text = ""
        selected_items.each do |item|
          teacher_text += ", " unless teacher_text.empty?
          teacher_text += item.text
          asignacion += teacher_text
          val_teacher = teacher_text
        end
        assign_class.text = asignacion + " a la materia (CLASS)."
      else
        puts "No items selected"
      end
    end

    tx2 = FXLabel.new(groupbox, "CLASS",:opts=>LAYOUT_EXPLICIT,
      :width=>150, :height=>23, :x=>470, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    assclass = FXList.new(groupbox,:opts => LIST_EXTENDEDSELECT|LAYOUT_EXPLICIT,
      :width=>150, :height=>75, :x=>470, :y=>115)
    assclass.appendItem("Química")
    assclass.appendItem("Matemáticas")
    assclass.appendItem("Historia Universal")
    assclass.appendItem("Ingles")    
    
    assclass.connect(SEL_COMMAND) do
      selected_items = []
      assclass.each { |item| selected_items << item if item.selected? }
      unless selected_items.empty?
        asignacion = "Asiganación del maestro, #{val_teacher} a la materia "
        class_text = ""
        selected_items.each do |item|
          class_text += ", " unless class_text.empty?
          class_text += item.text
          asignacion += class_text
        end
        assign_class.text = asignacion + "."
      else
        puts "No items selected"
      end
    end

    #ADD NEW CLASS
    tx1 = FXLabel.new(groupbox, "Add New Class",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>250, :height=>23, :x=>633, :y=>50)
    #. 
    
    tx2 = FXLabel.new(groupbox, "Name:",:opts=>LAYOUT_EXPLICIT, 
      :width=>50, :height=>20, :x=>633, :y=>90)
    nameClassTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>200, :height=>20, :x=>683, :y=>90)
    tx2.textColor = FXRGB(255, 0, 0)

    #BUTTON ADD CLASS
    add_class_Button = FXButton.new(groupbox, "ADD CLASS",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>197, :height=>20, :x=>683, :y=>120)
    #.

    #Registered users
    tx1 = FXLabel.new(groupbox, "Registered Users".upcase,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>875, :height=>23, :x=>7, :y=>240)
    #. 

    table = FXTable.new(groupbox, :opts => LAYOUT_EXPLICIT | TABLE_NO_COLSELECT,
      :width=>601, :height=>162, :x=>215, :y=>280)
    table.setTableSize(7, 6)

    table.rowHeaderMode = LAYOUT_FIX_WIDTH
    table.rowHeaderWidth = 0

    table.editable = false
    table.setColumnText(0, "No.")
    table.setColumnText(1, "Name")
    table.setColumnText(2, "Usuario")
    table.setColumnText(3, "Type User")
    table.setColumnText(4, "Action")
    table.setColumnText(5, "Action")

    table.setItemText(0,0, "01")
    table.setItemText(0,1, "Adain Magallanes")
    table.setItemText(0,2, "Química")
    table.setItemText(0,3, "Alumno")
    table.setItemText(0,4, "EDITAR")
    table.setItemText(0,5, "ELIMINAR")
    
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end  

app = FXApp.new  
Administrador.new(app,"Adain Magallenes", "Guille","Administrador General")  
app.create  
app.run


#tx2 = FXLabel.new(groupbox, "Class:",:opts=>LAYOUT_EXPLICIT,:width=>50, :height=>20, :x=>7, :y=>165)
#materias = FXComboBox.new(groupbox, 20,:opts => COMBOBOX_NO_REPLACE|LAYOUT_EXPLICIT|FRAME_GROOVE|FRAME_THICK,:width=>197, :height=>20, :x=>60, :y=>165)

#materias.numVisible = 3
#materias.editable = false
#materias.appendItem("Química")
#materias.appendItem("Matemáticas")
#materias.appendItem("Historia Universal")
#materias.appendItem("Ingles")

#materias.connect(SEL_COMMAND) do |sender, sel, data|
  #print "materia: ",sender.text,".\n"
#end