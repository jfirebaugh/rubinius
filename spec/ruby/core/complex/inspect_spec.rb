require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Complex#inspect" do
    it "returns (${real}+${image}i) for positive imaginary parts" do
      Complex(1).inspect.should == "(1+0i)"
      Complex(7).inspect.should == "(7+0i)"
      Complex(-1, 4).inspect.should == "(-1+4i)"
      Complex(-7, 6.7).inspect.should == "(-7+6.7i)"
    end

    it "returns (${real}-${image}i) for negative imaginary parts" do
      Complex(0, -1).inspect.should == "(0-1i)"
      Complex(-1, -4).inspect.should == "(-1-4i)"
      Complex(-7, -6.7).inspect.should == "(-7-6.7i)"
    end

    it "returns (1+0.0i) for Complex(1, 0.0)" do
      Complex(1, 0.0).inspect.should == "(1+0.0i)"
    end

    it "returns (1-0.0i) for Complex(1, -0.0)" do
      Complex(1, -0.0).inspect.should == "(1-0.0i)"
    end

    it "returns (1+Infinity*i) for Complex(1, Infinity)" do
      Complex(1, infinity_value).inspect.should == "(1+Infinity*i)"
    end

    it "returns (1-Infinity*i) for Complex(1, -Infinity)" do
      Complex(1, -infinity_value).inspect.should == "(1-Infinity*i)"
    end

    it "returns (1+NaN*i) for Complex(1, NaN)" do
      Complex(1, nan_value).inspect.should == "(1+NaN*i)"
    end

    it "sends #inspect to real and imaginary parts" do
      real = mock_numeric('real')
      imag = mock_numeric('imag')
      real.should_receive(:inspect).and_return("r")
      imag.should_receive(:inspect).and_return("i")
      imag.should_receive(:<).with(0).and_return(false)
      imag.should_receive(:abs).and_return(imag)
      Complex(real, imag).inspect.should == "(r+i*i)"
    end
  end
end
