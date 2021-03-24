require_relative 'Administrador'
require 'fox16'
include Fox  
class Login < FXMainWindow  
  def initialize(app, title, w, h)  
    @app = app
    super(app, title, :width => w, :height => h,:padding => 10)  

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
    passTextField = FXTextField.new(groupbox, 20,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y, 
        :width=>197, :height=>20, :x=>60, :y=>75)
    tx1.textColor = FXRGB(255, 0, 0)

    #BUTTON INGRESAR
    ingresarButton = FXButton.new(groupbox, "SING UP",nil,nil,0,:opts =>BUTTON_NORMAL|LAYOUT_EXPLICIT, 
        :width=>197, :height=>20, :x=>60, :y=>100)
    ingresarButton.connect(SEL_COMMAND) do
        if verifica(userTextField.text, passTextField.text)
            @typeuser = "Administrador"
            if (@typeuser == "Administrador")
              mainWindow2 = Administrador.new(@app,"Adain Magallanes",userTextField.text,@typeuser+" General")
              mainWindow2.create
              mainWindow2.show(PLACEMENT_SCREEN)
              self.close
            end
        else
            puts "ERROR"
        end
    
    
    end
  end  

  def create  
    super  
    show(PLACEMENT_SCREEN)  
  end 

  def verifica(user, pass)
    u="Guille"
    pa="pass1"
    if user==u && pass==pa
        return true
    else
        return false
    end    
  end
end  

app = FXApp.new  
Login.new(app, "LOGIN", 285, 160)  
app.create  
app.run
