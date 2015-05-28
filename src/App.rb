require 'rubygems'
require_relative 'Fractal.rb'
require 'wx'

class FractalApp < Wx::App
  @@width = 1600
  @@height = 1200
#List of IDs of UI elements  
  START_MENU = 10
  STOP_MENU = 11
  EXIT_MENU = 12  
      
  def visible(lines) #make lines from array of Lines a two dimensional array of coords
      array = []
      lines.each_with_index{|line, i|
        array[i] = []
        for j in 0..3
          if line.coord[j] < 0 then array[i][j] = 0
          elsif line.coord[j] > @@width then array[i][j] = @@width 
          else array[i][j] = line.coord[j].to_i end
        end
      }
      return array
  end
  def on_init
    @fractals = Fractal.sample
    @frame = Wx::Frame.new(nil, :size => [@@width, @@height])
#Create Menu
    menu_bar = Wx::MenuBar.new
    file_menu = Wx::Menu.new
    fractal_menu = Wx::Menu.new
    menu_bar.append(file_menu, '&File')
    menu_bar.append(fractal_menu, '&Fractal')
    fractal_menu.append(START_MENU, '&Draw', 'Start drawing')
    @frame.evt_menu(START_MENU) { void }
    fractal_menu.append(STOP_MENU, 'S&top', 'Stop drawing')
    @frame.evt_menu(STOP_MENU) { void }
    menu_exit = file_menu.append(EXIT_MENU, "E&xit\tAlt-X", 'Exit the program')
    @frame.evt_menu(EXIT_MENU) { exit }
    @frame.set_menu_bar(menu_bar)
#Create Controls    
    text1 = Wx::StaticText.new(@frame, -1, "Shape")
    text2 = Wx::StaticText.new(@frame, -1, "Iterations")
    choice = Wx::Choice.new(@frame, -1, Wx::Point.new(100,100), Wx::Size.new(-1,-1), @fractals[1])
    spin = Wx::SpinCtrl.new(@frame, -1, @fractals[2].last.to_s, Wx::DEFAULT_POSITION, Wx::Size.new(50,22), Wx::SP_VERTICAL)
    spin.set_range(0, 100);    spin.set_value(1)
    chbox = Wx::CheckBox.new(@frame, -1, "Add iteration")
    @frame.evt_choice(choice.get_id) { spin.set_value(@fractals[2][choice.get_selection])}
    button = Wx::Button.new(@frame, -1, 'Draw')
    @frame.evt_button(button.get_id) { start(choice.get_selection, spin.get_value, chbox.is_checked) }
#Set defaults
    choice.set_selection(@fractals[0].length-1)
    spin.set_value(@fractals[2].last)
#arrange UI elements    
    sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
    sizer2 = Wx::GridSizer.new(2,3,1,1)
    sizer2.add(text1)
    sizer2.add(choice)
    sizer2.add(button)
    sizer2.add(text2)
    sizer2.add(spin)
    sizer2.add(chbox)
    sizer.add(sizer2)
    @frame.set_sizer(sizer)      
    @frame.show
  end
  def start(shape, iterations, continue)
#    @g1 = Wx::Gauge.new(@frame, -1, iterations, Wx::Point.new(110,50), Wx::Size.new(250,25))   
    start_time = Time.now    
#Offscreen drawing buffer.
    buffer = Wx::Bitmap.new(@@width, @@height)
#Displays drawing.
    window = Wx::Window.new(@frame, :size => [@@width, @@height])
#White background
    buffer.draw do |surface|
        surface.pen = Wx::Pen.new(Wx::Colour.new(0, 0, 0), 0)
        surface.brush = Wx::WHITE_BRUSH
        surface.draw_rectangle(0, 0, @@width, @@height)
    end
    
    buffer.draw do |surface|        
      surface.pen = Wx::Pen.new(Wx::Colour.new(201, 0, 50),1)
      surface.pen.cap = Wx::CAP_ROUND
      visible(@fractals[0][shape].iter(iterations, continue)).each{|a| 
        surface.draw_line(a[0], a[1], a[2], a[3])
#        surface.draw_label("#{a[0]}, #{a[1]} -> #{a[2]}, #{a[3]}",Wx::Rect.new(a[0], a[1], a[0]+30, a[1]+30))
      } # конец прорисовки
    end #конец рисования в буфер
    @fractals = Fractal.sample  if continue == false#reset sample data
      
      update_window(window, buffer)
      puts Time.now-start_time
      sleep 0.1
  end
  def update_window(window, buffer)
      window.paint do |dc|
#Copy the buffer to the viewable window.
      dc.draw_bitmap(buffer, 0, 0, false)
  end
  end
  def void
      puts "dummy method"    
  end
end

FractalApp.new.main_loop
