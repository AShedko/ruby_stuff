require 'rspec'
require_relative './deck'

describe Deck do
  let(:deck) { Deck.new }

  context "Свойства методов empty? и empty:" do
    it "только что созданная колода является пустой" do
      expect(deck.empty?).to be true
    end

    it "пустой стек с добавленным в него элементом не является пустым" do
      deck.push_back(17)
      expect(deck.empty?).to be false
    end

    it "после вызова метода empty колода становится пустой" do
      deck. push_back(17)
      deck.empty
      expect(deck.empty?).to be true
    end
  end

  context "Особенности работы с пустой и полностью заполненной колодой:" do
    it "из пустой колоды нельзя ничего извлечь" do
      expect { deck.pop_front }.to raise_error(RuntimeError, 'Deck is empty')
      expect { deck.back }.to raise_error(RuntimeError, 'Deck is empty')
    end

    it "у пустой колоды ничего не лежит сверху или снизу" do
      expect { deck.front }.to raise_error(RuntimeError, 'Deck is empty')
    end

    it "в пустую колоду можно положить лишь ограниченное число элементов" do
      deck.empty
      Deck::DEF_SIZE.times { deck.push_back(85) }
      expect { deck.push_back(17) }.to raise_error(RuntimeError, 'Deck is full')
    end

    it "в пустую колоду можно положить лишь
    ограниченное число элементов снизу" do
      deck.empty
      Deck::DEF_SIZE.times { deck.push_front(85) }
      expect { deck.push_front(17) }.to raise_error(RuntimeError, 'Deck is full')
      expect { deck.push_back(17) }.to raise_error(RuntimeError, 'Deck is full')
    end
  end

  context "Особенности дисциплины обслуживания FIFO:" do
    it "первым пришёл - первым ушёл" do
      deck.push_back(17)
      deck.push_back(18)
      expect(deck.front).to eq 17
      expect(deck.pop_front).to eq 17
      expect(deck.front).to eq 18
      expect(deck.pop_front).to eq 18
    end
  end

  context "Особенности дисциплины обслуживания LIFO:" do
    it "первым пришёл - последним ушёл" do
      deck.push_front(17)
      deck.push_front(18)
      expect(deck.front).to eq 18
      expect(deck.pop_front).to eq 18
      expect(deck.front).to eq 17
      expect(deck.pop_front).to eq 17
    end
  end
end
