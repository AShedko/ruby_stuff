require 'rspec'
require_relative './queue'

describe Queue do

  let(:queue) { Queue.new }

  context "Свойства методов empty? и empty:" do
    it "только что созданный стек является пустым" do
      expect(queue.empty?).to be true
    end

    it "пустой стек с добавленным в него элементом не является пустым" do
      queue.enqueue(17)
      expect(queue.empty?).to be false
    end

    it "после вызова метода empty очередь становится пустой" do
      queue. enqueue(17)
      queue.empty
      expect(queue.empty?).to be true
    end
  end

  context "Особенности работы с пустой и полностью заполненной очередью:" do
    it "из пустой очереди нельзя ничего извлечь" do
      expect { queue.dequeue }.to raise_error(RuntimeError, 'Queue is empty')
    end

    it "у пустого стека ничего не лежит на вершине" do
      expect { queue.front }.to raise_error(RuntimeError, 'Queue is empty')
    end

    it "в пустую очередь можно положить лишь ограниченное число элементов" do
      queue.empty
      Queue::DEF_SIZE.times { queue.enqueue(85) }
      expect { queue.enqueue(17) }.to raise_error(RuntimeError, 'Queue is full')
    end
  end

  context "Особенности дисциплины обслуживания FIFO:" do
    it "первым пришёл - первым ушёл" do
      queue.enqueue(17)
      queue.enqueue(18)
      expect(queue.front).to eq 17
      expect(queue.dequeue).to eq 17
      expect(queue.front).to eq 18
      expect(queue.dequeue).to eq 18
    end
  end
end
