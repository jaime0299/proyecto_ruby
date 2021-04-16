require_relative 'database'
require_relative './Login'
require 'fox16'
include Fox  
class Alumno < FXMainWindow  
  def initialize(app,name,user,tipo)  
    @dataB = DatabaseSchool.new() 
    @nombreAl=name
    @app = app
    super(app, tipo.upcase, :width => 600, :height => 225, :padding => 10) 

    #print "Hi, Welcome to Student, #{user}" 
    
    groupbox = FXGroupBox.new(self, "",:opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fuente = FXFont.new(app,"Time New Roman, 120, BOLD,0")
    welcome_to_alum = FXLabel.new(groupbox,"Hi, Welcome to student, #{name}",
      :opts=>LAYOUT_EXPLICIT, :width=>563, :height=>26, :x=>7, :y=>10)
    welcome_to_alum.textColor = FXRGB(0, 0, 255)
    welcome_to_alum.font = fuente

    #INFO STUDENT
    tx1 = FXLabel.new(groupbox, "Info Student",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
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

    #Registered Classes
    tx1 = FXLabel.new(groupbox, "Registered Classes",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :width=>301, :height=>23, :x=>270, :y=>50)
    #. 

    table = FXTable.new(groupbox, :opts => LAYOUT_EXPLICIT | TABLE_NO_COLSELECT,
      :width=>301, :height=>102, :x=>270, :y=>90)
    table.setTableSize(4, 3)

    table.rowHeaderMode = LAYOUT_FIX_WIDTH
    table.rowHeaderWidth = 0

    table.editable = false
    table.setColumnText(0, "Teacher")
    table.setColumnText(1, "Class")
    table.setColumnText(2, "Grade")

    grades = @dataB.getGrades(@nombreAl)
    len = grades.length
    for i in 0...len do
      row=grades[i]
      table.setItemText(i,0, row[:teacher])
      table.setItemText(i,1, row[:class])
      table.setItemText(i,2, row[:cal].to_s)
    end

    #BUTTON CLOSE
    close_Button = FXButton.new(groupbox, "CLOSE",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
      :width=>100, :height=>20, :x=>156, :y=>165)
    close_Button.connect(SEL_COMMAND) do
        require_relative './Login.rb'
        mainWindow1 = Login.new(@app)
        mainWindow1.create
        mainWindow1.show
        self.close()
    end
    
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end  

#app = FXApp.new  
#Alumno.new(app,"Adain Magallenes", "Guille","Alumno")  
#app.create  
#app.run