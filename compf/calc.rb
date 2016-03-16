#!/usr/bin/env ruby
require_relative 'compf'
#
# Интерпретатор арифметических выражений вычисляет значения
# правильных арифметических формул, в которых в качестве
# операндов допустимы только цифры /^[0-9]$/
#
class Calc < Compf

  CONV_TABLE = {'R'=>">>" ,
                'L'=>"<<",
                "+"=>"+",
                "-"=>"-",
                "/"=>"/",
                "*"=>"*"
              }

  def initialize
    # Вызов метода initialize класса Compf
    super
    # Создание стека для работы стекового калькулятора
    @s = Stack.new
  end

  # Интерпретация арифметического выражения
  def compile(str)
    super
    @s.top
  end

  private

  #Приоритет операций
  def priority(c)
    (c == '+' or c == '-') ? 1 : c=='L' ? 0 : (c=='R') ? 3 : 2
  end

  # Проверка допустимости символа
  def check_symbol(c)
    raise "Недопустимый символ '#{c}'" if c !~ /[0-9]/
  end

  # Заключительная обработка цифры
  def process_value(c)
    @s.push(c.to_i)
  end

  # Заключительная обработка символа операции
  def process_oper(c)
    second, first = @s.pop, @s.pop
    @s.push(first.method(CONV_TABLE[c]).call(second))
  end
end

if $0 == __FILE__
  c = Calc.new
  loop do
    print "Арифметическое выражение: "
    str = gets.chomp
    print "Результат его вычисления: "
    puts c.compile(str)
    puts
  end
end
