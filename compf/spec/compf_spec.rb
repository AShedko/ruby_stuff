require 'rspec'
require_relative '../compf'

describe 'Компилятор формул' do
  let(:compf) { Compf.new }

  context 'один символ' do
    it 'a -> a' do
      expect(compf.compile('a')).to eq 'a'
    end

    it '+ -> +' do
      expect(compf.compile('+')).to eq '+'
    end
  end

  context 'допустимые операции' do
    it 'a+b -> a b +' do
      expect(compf.compile('a+b')).to eq 'a b +'
    end
    it 'a-b -> a b -' do
      expect(compf.compile('a-b')).to eq 'a b -'
    end
    it 'a*b -> a b *' do
      expect(compf.compile('a*b')).to eq 'a b *'
    end
    it 'a/b -> a b /' do
      expect(compf.compile('a/b')).to eq 'a b /'
    end
    it 'a>>b -> a b R' do
      expect(compf.compile('a>>b')).to eq 'a b R'
    end
    it 'a<<b -> a b L' do
      expect(compf.compile('a<<b')).to eq 'a b L'
    end
  end

  context 'порядок операций' do
    it 'a+c*b -> a c b * +' do
      expect(compf.compile('a+c*b')).to eq 'a c b * +'
    end

    it 'a*b/c -> a b * c /' do
      expect(compf.compile('a*b/c')).to eq 'a b * c /'
    end

    it 'a*(b/c) -> a c b / *' do
      expect(compf.compile('a*(b/c)')).to eq 'a b c / *'
    end

    it 'a+(b>>c) -> a c b R +' do
      expect(compf.compile('a+(b>>c)')).to eq 'a b c R +'
    end

    it 'a*b<<c -> a b * c L' do
      expect(compf.compile('a*b<<c')).to eq 'a b * c L'
    end

    it 'a+c*b>>d -> a c b d * + R' do
      expect(compf.compile('a+c*b')).to eq 'a c b * +'
    end
  end

  context 'скобки' do
    it '(a) -> a' do
      expect(compf.compile('(a)')).to eq 'a'
    end

    it '(((((a)))) -> a' do
      expect(compf.compile('(((((a))))')).to eq 'a'
    end

    it '(((((a+b)))) -> a b +' do
      expect(compf.compile('(((((a+b))))')).to eq 'a b +'
    end

    it '(((((((a+b)*((a+b))))))) -> a b + a b + *' do
      expect(compf.compile('(((((((a+b)*((a+b)))))))')).to eq 'a b + a b + *'
    end

    it '((((a)>>b))) -> a b R' do
      expect(compf.compile('((((a)>>b)))')).to eq 'a b R'
    end
  end

  context 'выражения' do
    it '(a+b)*c+(d-e)/f -> a b + c * d e - f / +' do
      expect(compf.compile('(a+b)*c+(d-e)/f')).to eq 'a b + c * d e - f / +'
    end

    it 'c*(c+c+c+c/(c-c-c-c)) -> c c c + c + c c c - c c - / *' do
      expect(compf.compile('c*(c+c+c+c/(c-c-c-c))')).to eq 'c c c + c + c c c - c - c - / + *'
    end

    it 'a/b*c+d*e/(f+g) -> a b / c * d e * f g + / +' do
      expect(compf.compile('a/b*c+d*e/(f+g)')).to eq 'a b / c * d e * f g + / +'
    end

    it 'a/b*(c+d*e)/(f+g) -> a b / c d e * + * f g + /' do
      expect(compf.compile('a/b*(c+d*e)/(f+g)')).to eq 'a b / c d e * + * f g + /'
    end

    it 'a+b*(c-d)*(c+(d-e)/a)/a -> a b c d - * c d e - a / + * a / +' do
      expect(compf.compile('a+b*(c-d)*(c+(d-e)/a)/a')).to eq 'a b c d - * c d e - a / + * a / +'
    end

    it '(c+(c*(c+(c+c/c))))/(c+c) -> c c c c c c/ + + * + c c + /' do
      expect(compf.compile('((c+(c*(c+(c+c/c)))))/(c+c)')).to eq 'c c c c c c / + + * + c c + /'
    end

    it 'c+(c+(c*(c+(c/(c*(c+c)))))) -> c c c c c c c + * / + * + +' do
      expect(compf.compile('c+(c+(c*(c+(c/(c*(c+c))))))')).to eq 'c c c c c c c c + * / + * + +'
    end

    it 'c-c+(c>>(c*(c<<(c/(c*(c<<c)))))) -> c c - c c c c c c c L * / L * R +' do
      expect(compf.compile('c-c+(c>>(c*(c<<(c/(c*(c<<c))))))')).to eq 'c c - c c c c c c c L * / L * R +'
    end

    it '(a+b>>c)<<(d/y)*z -> a b + c R d y / z * L' do
      expect(compf.compile('(a+b>>c)<<(d/y)*z')).to eq 'a b + c R d y / z * L'
    end

  end

end
