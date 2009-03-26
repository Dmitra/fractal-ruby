require 'rubygems'
require 'fractal.rb'
require 'wx'

class MyApp < Wx::App

  def on_init
    width = 1600
    height = 1200
    #Containing frame.
    frame = Wx::Frame.new(nil, :size => [width, height])
    frame.show
    #Offscreen drawing buffer.
    buffer = Wx::Bitmap.new(width, height)
    #Displays drawing.
    window = Wx::Window.new(frame, :size => [width, height])
    window.evt_paint do |event|
      update_window(window, buffer)
    end

    #White background
    buffer.draw do |surface|
        surface.pen = Wx::Pen.new(Wx::Colour.new(0, 0, 0), 0)
        surface.brush = Wx::WHITE_BRUSH
        surface.draw_rectangle(0, 0, width, height)
        end
          start = Time.now    
          
        fractal = Fractal.new(nil, nil, nil)
        lines = [[400,750,1100,760]]
        20.times do
        lines.each{|line|
        draw_lines = fractal.tick(line)
        lines += draw_lines                           #дописываем в конец массива линий две "из первой раздробленной"
        draw_lines.unshift(lines.shift)              #перенесение раздробленной линии во временный массив для прорисовки
    #Draw line.
      buffer.draw do |surface|
        draw_lines.each_with_index{|a, index| #первая линия из массива была раздроблена - она рисуется белым, две последние только что дописаны в массив
            if index == 0
              surface.pen = Wx::Pen.new(Wx::Colour.new(255, 255, 255),1)
            else
              surface.pen = Wx::Pen.new(Wx::Colour.new(201, 0, 50),1)
            end
          surface.pen.cap = Wx::CAP_ROUND
          surface.draw_line(a[0].to_i, a[1].to_i, a[2].to_i, a[3].to_i)
          } # конец прорисовки
        end #конец рисования в буфер
    #Update screen
        update_window(window, buffer)
        } # конец обработки очередной линии из массива lines
        end #конец итерации
        update_window(window, buffer)
        puts Time.now-start
        sleep 0.1
        end

    def update_window(window, buffer)
          window.paint do |dc|
          #Copy the buffer to the viewable window.
          dc.draw_bitmap(buffer, 0, 0, false)
    end
  end

end

app = MyApp.new
app.main_loop