require File.expand_path('../../../spec_helper', __FILE__)

describe "Fixnum#**" do
  describe "when the exponent is Fixnum 0" do
    it "returns 1" do
      (0 ** 0).should eql(1)
      (10 ** 0).should eql(1)
      ((-1) ** 0).should eql(1)
      ((-10) ** 0).should eql(1)
      (fixnum_max ** 0).should eql(1)
      (fixnum_min ** 0).should eql(1)
    end
  end

  describe "when the exponent is a positive Fixnum" do
    it "returns 0 when self is 0" do
      (0 ** 1).should eql(0)
      (0 ** 10).should eql(0)
      (0 ** fixnum_max).should eql(0)
    end

    it "returns self raised to the given exponent when self is positive" do
      (2 ** 1).should eql(2)
      (2 ** 2).should eql(4)
      (2 ** 40).should eql(1099511627776)
      (1 ** fixnum_max).should eql(1)
      (fixnum_max ** 1).should eql(fixnum_max)
    end

    it "returns self raised to the given exponent when self is negative" do
      ((-2) ** 1).should eql(-2)
      ((-2) ** 2).should eql(4)
      ((-2) ** 40).should eql(1099511627776)
      (fixnum_min ** 1).should eql(fixnum_min)

      if fixnum_max.even?
        ((-1) ** fixnum_max).should eql(1)
        ((-1) ** (fixnum_max - 1)).should eql(-1)
      else
        ((-1) ** fixnum_max).should eql(-1)
        ((-1) ** (fixnum_max - 1)).should eql(1)
      end
    end

    it "transparently overflows the result to a Bignum" do
      (2 ** 61).should eql(2305843009213693952)
      (2 ** 62).should eql(4611686018427387904)
      (2 ** 63).should eql(9223372036854775808)
      (2 ** 64).should eql(18446744073709551616)

      ((-2) ** 61).should eql(-2305843009213693952)
      ((-2) ** 62).should eql(4611686018427387904)
      ((-2) ** 63).should eql(-9223372036854775808)
      ((-2) ** 64).should eql(18446744073709551616)

      (fixnum_max ** 2).should eql(fixnum_max * fixnum_max)
      (fixnum_min ** 2).should eql(fixnum_min * fixnum_min)
    end

    it "returns +/-Infinity when exponent is too big" do
      #(2 ** 4194365).should be_an_instance_of(Bignum)
      #(2 ** 4194366).should be_positive_infinity

      #(2 ** fixnum_max).should be_positive_infinity
      #(fixnum_max ** fixnum_max).should be_positive_infinity
      #
      #if fixnum_max.even?
      #  ((-2) ** fixnum_max).should be_positive_infinity
      #  ((-2) ** (fixnum_max - 1)).should be_negative_infinity
      #  (fixnum_min ** fixnum_max).should be_positive_infinity
      #else
      #  ((-2) ** fixnum_max).should be_negative_infinity
      #  ((-2) ** (fixnum_max - 1)).should be_positive_infinity
      #  (fixnum_min ** fixnum_max).should be_negative_infinity
      #end
    end
  end

  describe "when the exponent is a negative Fixnum" do
    ruby_version_is "".."1.9" do
      conflicts_with :Rational do
        it "returns 1 when self is 1" do
          (1 ** -1).should eql(1)
          (1 ** -2).should eql(1)
          (1 ** fixnum_min).should eql(1)
        end

        it "returns 1 when self is -1 and the exponent is even" do
          ((-1) ** -2).should eql(1)
          ((-1) ** -10).should eql(1)

          if fixnum_min.even?
            ((-1) ** fixnum_min).should eql(1)
          end
        end

        it "returns -1 when self is -1 and the exponent is odd" do
          ((-1) ** -1).should eql(-1)
          ((-1) ** -11).should eql(-1)

          if fixnum_min.odd?
            ((-1) ** fixnum_min).should eql(-1)
          end
        end

        it "returns a Float when self is > 1" do
          (2 ** -1).should eql(0.5)
          (5 ** -1).should eql(0.2)
          (5 ** -2).should eql(0.04)
          (5 ** -3).should eql(0.008)
        end

        it "returns a Float when self is < -1" do
          ((-2) ** -1).should eql(-0.5)
          ((-5) ** -1).should eql(-0.2)
          ((-5) ** -2).should eql(0.04)
          ((-5) ** -3).should eql(-0.008)
        end

        it "returns Infinity when self is 0" do
          (0 ** -1).should be_positive_infinity
          (0 ** -5).should be_positive_infinity
          (0 ** fixnum_min).should be_positive_infinity
        end

        it "returns 0.0 when the exponent is too big" do
          (2 ** fixnum_min).should eql(0.0)
          ((-2) ** fixnum_min).should eql(0.0)
          (fixnum_max ** fixnum_min).should eql(0.0)
          (fixnum_min ** fixnum_min).should eql(0.0)
        end
      end
    end

    ruby_version_is "1.9" do
      it "returns self raised to the given exponent as a Rational when self is non-zero" do
        (1 ** -1).should eql(Rational(1))
        (1 ** -2).should eql(Rational(1))
        (2 ** -1).should eql(Rational(1, 2))
        (5 ** -1).should eql(Rational(1, 5))
        (5 ** -2).should eql(Rational(1, 25))
        ((-1) ** -1).should eql(Rational(-1))
        ((-1) ** -2).should eql(Rational(1))
        ((-2) ** -1).should eql(Rational(-1, 2))
        ((-5) ** -1).should eql(Rational(-1, 5))
        ((-5) ** -2).should eql(Rational(1, 25))

        (1 ** fixnum_min).should eql(Rational(1))

        if fixnum_min.even?
          ((-1) ** fixnum_min).should eql(Rational(1))
        else
          ((-1) ** fixnum_min).should eql(Rational(-1))
        end

        # Ruby 1.9 will actually attempt to calculate these.
        # (fixnum_max ** fixnum_min)
        # (fixnum_min ** fixnum_min)
      end

      it "raises ZeroDivisionError when self is 0" do
        lambda { (0 ** -1) }.should raise_error(ZeroDivisionError)
        lambda { (0 ** -5) }.should raise_error(ZeroDivisionError)
        lambda { (0 ** fixnum_min) }.should raise_error(ZeroDivisionError)
      end
    end
  end

  describe "when the exponent is a positive Bignum" do
    it "returns 0 when self is 0" do
      (0 ** (fixnum_max + 1)).should eql(0)
      (0 ** bignum_value).should eql(0)
    end

    it "returns 1 when self is 1" do
      (1 ** (fixnum_max + 1)).should eql(1)
      (1 ** bignum_value).should eql(1)
    end

    it "returns 1 when self is -1 and the exponent is even" do
      ((-1) ** bignum_value).should eql(1)

      if fixnum_max.odd?
        ((-1) ** (fixnum_max + 1)).should eql(1)
      end
    end

    it "returns -1 when self is -1 and the exponent is odd" do
      ((-1) ** bignum_value(1)).should eql(-1)

      if fixnum_max.even?
        ((-1) ** (fixnum_max + 1)).should eql(-1)
      end
    end

    it "returns Infinity (always positive) when self is > 1 or < -1" do
      (2 ** (fixnum_max + 1)).should be_positive_infinity
      (2 ** bignum_value).should be_positive_infinity
      ((-2) ** (fixnum_max + 1)).should be_positive_infinity
      ((-2) ** (fixnum_max + 2)).should be_positive_infinity
      (fixnum_max ** (fixnum_max + 1)).should be_positive_infinity
      (fixnum_max ** bignum_value).should be_positive_infinity
      (fixnum_min ** (fixnum_max + 1)).should be_positive_infinity
      (fixnum_min ** bignum_value).should be_positive_infinity
    end
  end

  describe "when the exponent is a negative Bignum" do
    ruby_version_is "".."1.9" do
      conflicts_with :Rational do
        it "returns 0 when self is 0" do
          (0 ** (fixnum_min - 1)).should eql(0)
          (0 ** -bignum_value).should eql(0)
        end

        it "returns 1 when self is 1" do
          (1 ** (fixnum_min - 1)).should eql(1)
          (1 ** -bignum_value).should eql(1)
        end

        it "returns 1 when self is -1 and the exponent is even" do
          ((-1) ** -bignum_value).should eql(1)
          ((-1) ** -bignum_value(10)).should eql(1)

          if fixnum_min.odd?
            ((-1) ** (fixnum_min - 1)).should eql(1)
          end
        end

        it "returns -1 when self is -1 and the exponent is odd" do
          ((-1) ** -bignum_value(1)).should eql(-1)
          ((-1) ** -bignum_value(11)).should eql(-1)

          if fixnum_min.even?
            ((-1) ** (fixnum_min - 1)).should eql(-1)
          end
        end

        it "returns 0.0 when self is > 1 or < -1" do
          (2 ** (fixnum_min - 1)).should eql(0.0)
          (2 ** -bignum_value).should eql(0.0)
          ((-2) ** (fixnum_min - 1)).should eql(0.0)
          ((-2) ** -bignum_value).should eql(0.0)
          (fixnum_max ** (fixnum_min - 1)).should eql(0.0)
          (fixnum_max ** -bignum_value).should eql(0.0)
          (fixnum_min ** (fixnum_min - 1)).should eql(0.0)
          (fixnum_min ** -bignum_value).should eql(0.0)
        end
      end
    end

    ruby_version_is "1.9" do
      ruby_bug "#5713", "2.0" do
        it "raises ZeroDivisionError when self is 0" do
          lambda { (0 ** (fixnum_min - 1)) }.should raise_error(ZeroDivisionError)
          lambda { (0 ** -bignum_value) }.should raise_error(ZeroDivisionError)
        end
      end

      ruby_bug "#5715", "2.0" do
        it "returns Rational(1) when self is 1" do
          (1 ** (fixnum_min - 1)).should eql(Rational(1))
          (1 ** -bignum_value).should eql(Rational(1))
        end

        it "returns Rational(1) when self is -1 and the exponent is even" do
          ((-1) ** -bignum_value).should eql(Rational(1))
          ((-1) ** -bignum_value(10)).should eql(Rational(1))

          if fixnum_min.odd?
            ((-1) ** (fixnum_min - 1)).should eql(Rational(1))
          end
        end

        it "returns Rational(-1) when self is -1 and the exponent is odd" do
          ((-1) ** -bignum_value(1)).should eql(Rational(-1))
          ((-1) ** -bignum_value(11)).should eql(Rational(-1))

          if fixnum_min.even?
            ((-1) ** (fixnum_min - 1)).should eql(Rational(-1))
          end
        end
      end

      it "returns 0.0 when self is > 1 or < -1" do
        (2 ** (fixnum_min - 1)).should eql(0.0)
        (2 ** -bignum_value).should eql(0.0)
        ((-2) ** (fixnum_min - 1)).should eql(0.0)
        ((-2) ** -bignum_value).should eql(0.0)
        (fixnum_max ** (fixnum_min - 1)).should eql(0.0)
        (fixnum_max ** -bignum_value).should eql(0.0)
        (fixnum_min ** (fixnum_min - 1)).should eql(0.0)
        (fixnum_min ** -bignum_value).should eql(0.0)
      end
    end
  end

  describe "when the exponent is Float +/-0.0" do
    it "returns 1.0" do
      (0 ** 0.0).should eql(1.0)
      (1 ** 0.0).should eql(1.0)
      (10 ** 0.0).should eql(1.0)
      ((-1) ** 0.0).should eql(1.0)
      ((-10) ** 0.0).should eql(1.0)
      (fixnum_max ** 0.0).should eql(1.0)
      (fixnum_min ** 0.0).should eql(1.0)

      (0 ** -0.0).should eql(1.0)
      (1 ** -0.0).should eql(1.0)
      (10 ** -0.0).should eql(1.0)
      ((-1) ** -0.0).should eql(1.0)
      ((-10) ** -0.0).should eql(1.0)
      (fixnum_max ** -0.0).should eql(1.0)
      (fixnum_min ** -0.0).should eql(1.0)
    end
  end

  describe "when the exponent is a positive Float" do
    it "returns 0.0 when self is 0" do
      (0 ** 0.5).should eql(0.0)
      (0 ** 123.456).should eql(0.0)
    end

    it "returns 1.0 when self is 1" do
      (1 ** 0.5).should eql(1.0)
      (1 ** 123.456).should eql(1.0)
    end

    it "returns self raised to the given exponent as a Float when self is > 1" do
      (9 ** 0.5).should eql(3.0)
    end

    ruby_version_is "".."1.9" do
      it "returns NaN when self is negative" do
        ((-1) ** 0.5).should be_nan
        ((-8) ** (1.0/3)).should be_nan
      end
    end

    ruby_version_is "1.9" do
      it "returns a Complex when self is negative" do
        ((-1) ** 0.5).should be_close(Complex(6.123234e-17, 1.0), TOLERANCE)
        ((-8) ** (1.0/3)).should be_close(Complex(1, 1.73205), TOLERANCE)
      end
    end
  end

  describe "when the exponent is a negative Float" do
    it "returns Infinity when self is 0" do
      (0 ** -0.5).should be_positive_infinity
      (0 ** -123.456).should be_positive_infinity
    end

    it "returns 1.0 when self is 1" do
      (1 ** -0.5).should eql(1.0)
      (1 ** -123.456).should eql(1.0)
    end

    it "returns self raised to the given exponent as a Float when self is > 1" do
      (9 ** -0.5).should be_close(1.0/3, TOLERANCE)
    end

    ruby_version_is "".."1.9" do
      it "returns NaN when self is negative" do
        ((-1) ** -0.5).should be_nan
        ((-8) ** (-1.0/3)).should be_nan
      end
    end

    ruby_version_is "1.9" do
      it "returns a Complex when self is negative" do
        ((-1) ** -0.5).should be_close(Complex(6.123234e-17, -1.0), TOLERANCE)
        ((-8) ** (-1.0/3)).should be_close(Complex(0.25, -0.43301), TOLERANCE)
      end
    end
  end

  describe "when the exponent is +Infinity" do
    it "returns 0.0 when self is 0" do
      (0 ** infinity_value).should eql(0.0)
    end

    it "returns 1.0 when self is +/-1" do
      (1 ** infinity_value).should eql(1.0)
      ((-1) ** infinity_value).should eql(1.0)
    end

    it "returns +Infinity when self is > 1 or < -1" do
      (2 ** infinity_value).should be_positive_infinity
      (10 ** infinity_value).should be_positive_infinity
      ((-2) ** infinity_value).should be_positive_infinity
      ((-10) ** infinity_value).should be_positive_infinity
    end
  end

  describe "when the exponent is -Infinity" do
    it "returns +Infinity when self is 0" do
      (0 ** -infinity_value).should be_positive_infinity
    end

    it "returns 1.0 when self is +/-1" do
      (1 ** -infinity_value).should eql(1.0)
      ((-1) ** -infinity_value).should eql(1.0)
    end

    it "returns 0.0 when self is > 1 or < -1" do
      (2 ** -infinity_value).should eql(0.0)
      (10 ** -infinity_value).should eql(0.0)
      ((-2) ** -infinity_value).should eql(0.0)
      ((-10) ** -infinity_value).should eql(0.0)
    end
  end

  describe "when the exponent is NaN" do
    conflicts_with :Rational do
      it "returns 0.0 when self is 0" do
        (0 ** nan_value).should eql(0.0)
      end
    end

    it "returns 1.0 when self is 1" do
      (1 ** nan_value).should eql(1.0)
    end

    it "returns NaN when self is > 1" do
      (2 ** nan_value).should be_nan
      (10 ** nan_value).should be_nan
    end

    ruby_version_is "".."1.9" do
      it "returns NaN when self is < -1" do
        ((-1) ** nan_value).should be_nan
        ((-2) ** nan_value).should be_nan
        ((-10) ** nan_value).should be_nan
      end
    end

    ruby_version_is "1.9" do
      it "returns Complex(NaN, NaN) when self is < -1" do
        ((-1) ** nan_value).real.should be_nan
        ((-1) ** nan_value).imag.should be_nan
        ((-2) ** nan_value).real.should be_nan
        ((-2) ** nan_value).imag.should be_nan
        ((-10) ** nan_value).real.should be_nan
        ((-10) ** nan_value).imag.should be_nan
      end
    end
  end

  describe "when the exponent is any other type" do
    ruby_version_is "".."1.9" do
      conflicts_with :Rational do
        it "coerces the argument" do
          obj = mock_numeric('10')
          obj.should_receive(:coerce).with(13).and_return([2, 13])
          (13 ** obj).should eql(8192)
        end

        it "raises a TypeError if the exponent can't be coerced" do
          lambda { 13 ** "10"    }.should raise_error(TypeError)
          lambda { 13 ** :symbol }.should raise_error(TypeError)
        end
      end
    end

    ruby_version_is "1.9" do
      it "coerces the argument" do
        obj = mock('10')
        obj.should_receive(:coerce).with(13).and_return([2, 13])
        (13 ** obj).should eql(8192)
      end

      it "raises a TypeError if the exponent can't be coerced" do
        lambda { 13 ** "10"    }.should raise_error(TypeError)
        lambda { 13 ** :symbol }.should raise_error(TypeError)
      end
    end
  end
end
