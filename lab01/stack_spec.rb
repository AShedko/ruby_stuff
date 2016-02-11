require 'rspec'
require_relative './stack'

describe Stack do

  let(:stack) { Stack.new }

  context "Свойства методов empty? и empty:" do
    it "только что созданный стек является пустым" do
      expect(stack.empty?).to be true
    end

    it "пустой стек с добавленным в него элементом не является пустым" do
      stack.push(17)
      expect(stack.empty?).to be false
    end

    it "после вызова метода empty стек становится пустым" do
      stack.push(17)
      stack.empty
      expect(stack.empty?).to be true
    end
  end

  context "Особенности работы с пустым и полностью заполненным стеком:" do
    it "из пустого стека нельзя ничего извлечь" do
      expect{stack.pop}.to raise_error(RuntimeError, "Stack is empty")
    end

    it "у пустого стека ничего не лежит на вершине" do
      expect{stack.top}.to raise_error(RuntimeError, "Stack is empty")
    end

    it "в пустой стек можно положить лишь ограниченное число элементов" do
      Stack::DEF_SIZE.times{stack.push(17)}
      expect{stack.push(17)}.to raise_error(RuntimeError, "Stack is full")
    end
  end

  context "Особенности дисциплины обслуживания LIFO:" do
    it "первым пришёл - последним ушёл" do
      stack.push(17)
      stack.push(18)
      expect(stack.top).to eq 18
      expect(stack.pop).to eq 18
      expect(stack.top).to eq 17
      expect(stack.pop).to eq 17
    end
  end
end
