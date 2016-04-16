require 'rspec'
require_relative '../r2point'

describe R2Point do

  EPS = 1.0e-12

  context "Расстояние dist" do

    it "от точки до самой себя равно нулю" do
      a = R2Point.new(1.0,1.0)
      expect(a.dist(R2Point.new(1.0,1.0))).to be_within(EPS).of(0.0)
    end

    it "от одной точки до отличной от неё другой положительно" do
      a = R2Point.new(1.0,1.0)
      expect(a.dist(R2Point.new(1.0,0.0))).to be_within(EPS).of(1.0)
      expect(a.dist(R2Point.new(0.0,0.0))).to be_within(EPS).of(Math.sqrt(2.0))
    end

  end

  context "Площадь area" do

    let(:a) { R2Point.new(0.0,0.0)  }
    let(:b) { R2Point.new(1.0,-1.0) }
    let(:c) { R2Point.new(2.0,0.0)  }

    it "равна нулю, если все вершины совпадают" do
      expect(R2Point.area(a,a,a)).to be_within(EPS).of(0.0)
    end

    it "равна нулю, если вершины лежат на одной прямой" do
      b = R2Point.new(1.0,0.0)
      expect(R2Point.area(a,b,c)).to be_within(EPS).of(0.0)
    end

    it "положительна, если обход вершин происходит против часовой стрелки" do
      expect(R2Point.area(a,b,c)).to be_within(EPS).of(1.0)
    end

    it "отрицательна, если обход вершин происходит по часовой стрелки" do
      expect(R2Point.area(a,c,b)).to be_within(EPS).of(-1.0)
    end

  end

  context "inside? для прямоугольника с вершинами (0,0) и (2,1) утверждает:" do

    let(:a) { R2Point.new(0.0,0.0) }
    let(:b) { R2Point.new(2.0,1.0) }

    it "точка (1,0.5) внутри" do
      expect(R2Point.new(1.0,0.5).inside?(a,b)).to be true
    end

    it "точка (1,0.5) внутри" do
      expect(R2Point.new(1.0,0.5).inside?(b,a)).to be true
    end

    it "точка (1,1.5) снаружи" do
      expect(R2Point.new(1.0,1.5).inside?(a,b)).to be false
    end

    it "точка (1,1.5) снаружи" do
      expect(R2Point.new(1.0,1.5).inside?(b,a)).to be false
    end

  end

  context "light? для ребра с вершинами (0,0) и (1,0) утверждает:" do

    let(:a) { R2Point.new(0.0,0.0) }
    let(:b) { R2Point.new(1.0,0.0) }

    it "из точки (0.5,0.0) оно не освещено" do
      expect(R2Point.new(0.5,0.0).light?(a,b)).to be false
    end

    it "из точки (0.5,-0.5) оно освещено" do
      expect(R2Point.new(0.5,-0.5).light?(a,b)).to be true
    end

    it "из точки (2.0,0.0) оно освещено" do
      expect(R2Point.new(2.0,0.0).light?(a,b)).to be true
    end

    it "из точки (0.5,0.5) оно не освещено" do
      expect(R2Point.new(0.5,0.5).light?(a,b)).to be false
    end

    it "из точки (-1.0,0.0) оно освещено" do
      expect(R2Point.new(-1.0,0.0).light?(a,b)).to be true
    end

  end

  context "Расстояние до прямоугольника" do
    let(:a) { R2Point.new(-1.0,-1.0) }
    let(:b) { R2Point.new(1.0,1.0) }

    it "Есть пересечение" do
      expect(R2Point.new(2.0,0.0).distance_rect(R2Point.new(0.0,0.0),a,b)).to eql 0
    end

    it "Точка на разделяющей линии" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(3.0,0),a,b)).to be_within(EPS).of(1.341640786499874)
    end

    it "Cлучай параллельности стороны" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(-0.5,2.0),a,b)).to be_within(EPS).of(1.0)
    end

    it "Cлучай параллельности стороны 2" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(2.0,0.5),a,b)).to be_within(EPS).of(1.0)
    end

    it "Cлучай отрезка в одном квадранте" do
      expect(R2Point.new(3.0,0.0).distance_rect(R2Point.new(0.0,3.0),a,b)).to be_within(EPS).of(0.7071067811865476)
    end

    it "Cлучай отрезка в противолежащих квадрантах" do
      expect(R2Point.new(1.0,4.0).distance_rect(R2Point.new(-4.0,-1.0),a,b)).to be_within(EPS).of(0.7071067811865476)
    end

    it "Нет пересечения случай внутри" do
      expect(R2Point.new(0.0,0.0).distance_rect(R2Point.new(0.5,0.5),a,b)).to eql 0
    end

    it "Cлучай точки на оси" do
      expect(R2Point.new(-3.0,0.0).distance_rect(R2Point.new(-3.0,0.0),a,b)).to be_within(EPS).of(2)
    end

  end

  context "Расстояние до другого прямоугольника" do
    let(:a) { R2Point.new(-1.0,1.0) }
    let(:b) { R2Point.new(1.0,-1.0) }

    it "Точка на разделяющей линии" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(3.0,0),a,b)).to be_within(EPS).of(1.341640786499874)
    end

    it "Cлучай параллельности стороны" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(-0.5,2.0),a,b)).to be_within(EPS).of(1.0)
    end

    it "Cлучай параллельности стороны 2" do
      expect(R2Point.new(2.0,2.0).distance_rect(R2Point.new(2.0,0.5),a,b)).to be_within(EPS).of(1.0)
    end

    it "Cлучай отрезка в одном квадранте" do
      expect(R2Point.new(3.0,0.0).distance_rect(R2Point.new(0.0,3.0),a,b)).to be_within(EPS).of(0.7071067811865476)
    end

    it "Cлучай отрезка в противолежащих квадрантах" do
      expect(R2Point.new(1.0,4.0).distance_rect(R2Point.new(-4.0,-1.0),a,b)).to be_within(EPS).of(0.7071067811865476)
    end

    it "Нет пересечения случай внутри" do
      expect(R2Point.new(0.0,0.0).distance_rect(R2Point.new(0.5,0.5),a,b)).to eql 0
    end

    it "Cлучай точки на оси" do
      expect(R2Point.new(-3.0,0.0).distance_rect(R2Point.new(-3.0,0.0),a,b)).to be_within(EPS).of(2)
    end
  end

  context "angle для 3-х точек" do
    let(:a) { R2Point.new(0.0,0.0) }
    let(:b) { R2Point.new(0.0,1.0) }
    it "Acute angle" do
      expect(R2Point.new(-1.0,0.5).ac_angle?(a,b)).to be true
    end

    it "Obtuse angle" do
      expect(R2Point.new(-0.4,0.5).ac_angle?(a,b)).to be false
    end

    it "Right angle" do
      expect(R2Point.new(-0.5,0.5).ac_angle?(a,b)).to be false
    end

    it "Another Right angle" do
      expect(b.ac_angle?(R2Point.new(0,1),R2Point.new(0,-1))).to be false
    end

    it "180 deg angle" do
      expect(a.ac_angle?(R2Point.new(0,-1),b)).to be false
    end
  end
end
