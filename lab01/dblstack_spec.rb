require 'rspec'
require_relative './dblstack'

describe DblStack do

  let(:stack) { DblStack.new }

  context "Свойства методов empty? и empty:" do
    it "только что созданный стек является пустым" do
      expect(stack.empty?).to be true
    end

    it "пустой левый стек с добавленным в него элементом не является пустым" do
      stack.push(0,17)
      expect(stack.empty?(0)).to be false
    end

    it "пустой правый стек с добавленным в него элементом не является пустым" do
      stack.push(1,17)
      expect(stack.empty?(1)).to be false
    end

    it "после вызова метода empty стек становится пустым" do
      stack.push(0,17)
      stack.empty
      expect(stack.empty?).to be true
    end
  end

  context "Ошибки связанные с неправильным номером стека:" do
    it "top (2) should be inacsessible" do
      expect {stack.top(2)}.to raise_error(RuntimeError, "Wrong stack")
    end

    it "pop (2) should be inacsessible" do
      expect {stack.pop(2)}.to raise_error(RuntimeError, "Wrong stack")
    end

    it "empty (2) should be inacsessible" do
      expect {stack.empty(2)}.to raise_error(RuntimeError, "Wrong stack")
    end

    it "push (2) should be impossible" do
      expect {stack.push(2,10)}.to raise_error(RuntimeError, "Wrong stack")
    end
  end
  context "Особенности работы с пустым и полностью заполненным стеком:" do
    it "из пустого стека нельзя ничего извлечь" do
      expect { stack.pop(0) }.to raise_error(RuntimeError, "Stack is empty")
      expect { stack.pop(1) }.to raise_error(RuntimeError, "Stack is empty")
    end

    it "у пустого стека ничего не лежит на вершине" do
      expect { stack.top(0) }.to raise_error(RuntimeError, "Stack is empty")
      expect { stack.top(1) }.to raise_error(RuntimeError, "Stack is empty")
    end

    it "в пустой стек можно положить лишь ограниченное число элементов слева" do
      DblStack::DEF_SIZE.times { stack.push(0, 17) }
      expect{ stack.push(0, 17) }.to raise_error(RuntimeError, "Stacks are full")
    end
    it "в пустой стек можно положить лишь ограниченное число элементов справа" do
      DblStack::DEF_SIZE.times { stack.push(1, 17) }
      expect { stack.push(1, 17) }.to raise_error(RuntimeError, "Stacks are full")
    end

    it "в пустой стек можно положить лишь ограниченное число элементов справа и справа" do
      h = DblStack::DEF_SIZE
      (h - 1).times { stack.push(0, 17)}
      stack.push(1, 29)
      expect { stack.push(1,17) }.to raise_error(RuntimeError, "Stacks are full")
    end
  end

  context "Особенности дисциплины обслуживания LIFO 0 :" do
    it "первым пришёл - последним ушёл" do
      stack.push(0,17)
      stack.push(0,18)
      expect(stack.top(0)).to eq 18
      expect(stack.pop(0)).to eq 18
      expect(stack.top(0)).to eq 17
      expect(stack.pop(0)).to eq 17
    end
  end

  context "Особенности дисциплины обслуживания LIFO 1 :" do
    it "первым пришёл - последним ушёл" do
      stack.push(1, 17)
      stack.push(1, 18)
      expect(stack.top(1)).to eq 18
      expect(stack.pop(1)).to eq 18
      expect(stack.top(1)).to eq 17
      expect(stack.pop(1)).to eq 17
    end
  end
end
