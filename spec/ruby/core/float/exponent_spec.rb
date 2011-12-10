require File.expand_path('../../../spec_helper', __FILE__)

describe "Float#**" do
  describe "with an Integer exponent" do
    it "computes the value of self raised to the given power" do
      (2.3 ** 3).should be_close(12.167, TOLERANCE)
      (5.2 ** -1).should be_close(0.192307692307692, TOLERANCE)
    end

    it "returns +Infinity when self is +0.0 and exponent is < 0 and odd" do
      (0.0 ** -1).should be_positive_infinity
      (0.0 ** -3).should be_positive_infinity
    end

    it "returns -Infinity when self is -0.0 and exponent is < 0 and odd" do
      ((-0.0) ** -1).should be_negative_infinity
      ((-0.0) ** -3).should be_negative_infinity
    end

    it "returns +Infinity when self is +/-0.0 and exponent is < 0 and even" do
      (0.0 ** -2).should be_positive_infinity
      (0.0 ** -4).should be_positive_infinity
      ((-0.0) ** -2).should be_positive_infinity
      ((-0.0) ** -4).should be_positive_infinity
    end

    it "returns 1.0 when the exponent is 0" do
      [0.0, -0.0, 5.3, -2.5, infinity_value, -infinity_value, nan_value].each do |f|
        (f ** 0).should eql(1.0)
      end
    end
  end

  describe "with a Float exponent" do
    it "computes the value of self raised to the given power" do
      (9.5 ** 0.5).should be_close(3.08220700148449, TOLERANCE)
    end

    it "returns a positive Float when self is negative and the exponent is an even integer" do
      ((-2.0) ** 2.0).should == 4
    end

    it "returns a negative Float when self is negative and the exponent is an odd integer" do
      ((-2.0) ** 3.0).should == -8
    end

    ruby_version_is "".."1.9" do
      # This is unspecified because pow, the underlying C function, is unspecified in this case.
      it "returns an unspecified Float value when self is negative and the exponent is a finite non-integer" do
        ((-8.0) ** 0.33).should be_an_instance_of(Float)
      end
    end

    ruby_version_is "1.9" do
      it "returns a Complex when self is negative and the exponent is a finite non-integer" do
        ((-8.0) ** 0.33).should be_close(Complex(1.01105, 1.70959), TOLERANCE)
      end
    end

    it "returns +Infinity when |self| < 1 and the exponent is -Infinity" do
      (0.5 ** -infinity_value).should be_positive_infinity
      ((-0.5) ** -infinity_value).should be_positive_infinity
    end

    it "returns +0 when |self| > 1 and the exponent is -Infinity" do
      (1.2 ** -infinity_value).should be_positive_zero
      ((-1.2) ** -infinity_value).should be_positive_zero
    end

    it "returns +0 when |self| < 1 and the exponent is +Infinity" do
      (0.5 ** infinity_value).should be_positive_zero
      ((-0.5) ** infinity_value).should be_positive_zero
    end

    it "returns +Infinity when |self| > 1 and the exponent is +Infinity" do
      (1.2 ** infinity_value).should be_positive_infinity
      ((-1.2) ** infinity_value).should be_positive_infinity
    end
  end

  describe "with an exponent of other type" do

  end
end
