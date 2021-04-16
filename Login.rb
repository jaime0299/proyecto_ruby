require_relative 'database' 
require 'fox16'
include Fox

class Login < FXMainWindow  
  def initialize(app)  
    @dataB = DatabaseSchool.new() 
    @app = app
    super(app, "LOGIN", :width => 285, :height => 160,:padding => 10)  

    groupbox = FXGroupBox.new(self, "",:opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    
    welcome_to_app = FXLabel.new(groupbox,"LOGIN",:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y, 
        :width=>250, :height=>20, :x=>7, :y=>20)
    welcome_to_app.textColor = FXRGB(0, 0, 0)

    #USER
    tx1 = FXLabel.new(groupbox, "User:",:opts=>LAYOUT_EXPLICIT, 
        :width=>50, :height=>20, :x=>7, :y=>50)
    userTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y, 
        :width=>197, :height=>20, :x=>60, :y=>50)
    tx1.textColor = FXRGB(255, 0, 0)

    #PASSWORD
    tx1 = FXLabel.new(groupbox, "Password:",:opts=>LAYOUT_EXPLICIT, 
        :width=>50, :height=>20, :x=>7, :y=>75)
    passTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y|TEXTFIELD_PASSWD, 
        :width=>197, :height=>20, :x=>60, :y=>75)
    tx1.textColor = FXRGB(255, 0, 0)

    #BUTTON INGRESAR
    ingresarButton = FXButton.new(groupbox, "SING IN",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
        :width=>197, :height=>20, :x=>60, :y=>100)
    ingresarButton.connect(SEL_COMMAND) do
        if verifica(userTextField.text, passTextField.text)
            @typeuser = @user[3]
            if (@typeuser == "Administrator")
                require_relative './Administrador'
                mainWindow2 = Administrador.new(@app,@user[1],@user[0],@typeuser)
                mainWindow2.create
                mainWindow2.show(PLACEMENT_SCREEN)
                self.close
            elsif (@typeuser == "Teacher")
                require_relative './Maestro'    
                mainWindow3 = Maestro.new(@app,@user[1],@user[0],@typeuser)
                mainWindow3.create
                mainWindow3.show(PLACEMENT_SCREEN)
                self.close
            elsif (@typeuser == "Student")
                require_relative './Alumno'
                mainWindow4 = Alumno.new(@app,@user[1],@user[0],@typeuser)
                mainWindow4.create
                mainWindow4.show(PLACEMENT_SCREEN)
                self.close
            end
        else
            FXMessageBox.error(@app, MBOX_OK, "LOGIN", "Wrong credentials, check your data")
        end   
    end
  end  

  def create  
    super  
    show(PLACEMENT_SCREEN)  
  end 

  def verifica(user, pass)
    ban, usuario = @dataB.verificaLog(user, pass)
    @user = usuario
    return ban
  end
end  

if __FILE__ == $0
    app = FXApp.new  
    Login.new(app)  
    app.create  
    app.run
end