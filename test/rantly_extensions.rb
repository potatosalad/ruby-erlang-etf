require 'rantly/minitest_extensions'
require 'rantly/shrinks'
require 'securerandom'

class Rantly

  UTF8_ENCODING = Encoding.find('utf-8')
  ERLANG_ETF_SMALL_BIG_MIN = (-1 << (255 * 8)) + 1
  ERLANG_ETF_SMALL_BIG_MAX = (+1 << (255 * 8)) - 1
  ERLANG_ETF_LARGE_BIG_MIN = ERLANG_ETF_SMALL_BIG_MIN * 2
  ERLANG_ETF_LARGE_BIG_MAX = ERLANG_ETF_SMALL_BIG_MAX * 2

  def erlang_etf_atom(size = self.size, strict: false)
    return Erlang::ETF::Atom[Erlang::Atom[random_string(size)]]
  end

  def erlang_etf_atom_utf8(size = self.size, strict: false)
    return Erlang::ETF::AtomUTF8[Erlang::Atom[utf8_string(size), utf8: true]]
  end

  def erlang_etf_binary(size = self.size, strict: false)
    return Erlang::ETF::Binary[Erlang::Binary[random_string(size)]]
  end

  def erlang_etf_bit_binary(size = self.size, bits = self.range(1, 8), strict: false)
    return Erlang::ETF::BitBinary[Erlang::Bitstring[random_string(size), bits: bits]]
  end

  def erlang_etf_export(size = self.size, strict: false, &block)
    mod, function, arity = if block_given?
      instance_exec(&block)
    else
      [
        random_erlang_etf_atom(range(0, size & 0xff), strict: strict),
        random_erlang_etf_atom(range(0, size & 255), strict: strict),
        Erlang::ETF::SmallInteger[range(0, size & 255)]
      ]
    end
    term = Erlang::Export[Erlang.from(mod), Erlang.from(function), Erlang.from(arity)]
    return Erlang::ETF::Export[term] if strict == false
    return Erlang::ETF::Export[term, mod, function, arity]
  end

  def erlang_etf_float(strict: false)
    float_string = nil
    float_object = nil
    while float_string.nil? or float_object.to_s.include?("Infinity")
      e = range(-323, 308)
      sign = (range(0, 1) == 0) ? '' : '-'
      integer = range(0, 9)
      fractional = Array.new(20); 20.times { |i| fractional[i] = range(0, 9) }
      float_string = "#{sign}#{integer}.#{fractional.join}e#{(e >= 0) ? '+' : ''}#{e}"
      float_object = ::BigDecimal.new(::BigDecimal.new(float_string).to_s).to_f
    end
    float = Erlang::Float[float_string, old: true]
    return Erlang::ETF::Float[float] if strict == false
    return Erlang::ETF::Float[float, float_string.ljust(31, "\0")]
  end

  def erlang_etf_integer(strict: false)
    int = freq(
      [1, :range, (-(1 << 31) + 1), -1],
      [1, :range, 256, (+(1 << 31) - 1)]
    )
    return Erlang::ETF::Integer[int]
  end

  def erlang_etf_large_big(strict: false)
    integer = freq(
      [1, :range, ERLANG_ETF_LARGE_BIG_MIN, ERLANG_ETF_SMALL_BIG_MIN - 1],
      [1, :range, ERLANG_ETF_SMALL_BIG_MAX + 1, ERLANG_ETF_LARGE_BIG_MAX]
    )
    return Erlang::ETF::LargeBig[integer]
  end

  def erlang_etf_large_tuple(size = self.size, depth = 0, arity: nil, strict: false, &block)
    arity ||= (size >= 256) ? size : 256
    elements = if block_given?
      arity.times.map(&block)
    else
      arity.times.map { random_erlang_etf_term(size / 2, depth - 1, strict: strict) }
    end
    term = Erlang::Tuple[*(elements.map { |element| Erlang.from(element) })]
    return Erlang::ETF::LargeTuple[term] if strict == false
    return Erlang::ETF::LargeTuple[term, elements]
  end

  def erlang_etf_list(size = self.size, depth = 0, strict: false, &block)
    length = size
    elements = if block_given?
      length.times.map(&block)
    else
      length.times.map { random_erlang_etf_term(size / 2, depth - 1, strict: strict) }
    end
    term = Erlang::List[*(elements.map { |element| Erlang.from(element) })]
    return Erlang::ETF::List[term] if strict == false
    tail = Erlang::ETF::Nil[Erlang::Nil]
    return Erlang::ETF::List[term, elements, tail]
  end

  def erlang_etf_list_improper(size = self.size, depth = 0, tail = nil, strict: false, &block)
    length = size
    elements = if block_given?
      length.times.map(&block)
    else
      length.times.map { random_erlang_etf_term(size / 2, depth - 1, strict: strict) }
    end
    if tail.nil?
      tail = random_erlang_etf_term(size / 2, depth - 1, strict: strict)
    elsif tail.is_a?(Proc)
      tail = instance_exec(&tail)
    end
    while tail.kind_of?(Erlang::ETF::Nil) or tail.kind_of?(Erlang::ETF::String) or (tail.kind_of?(Erlang::ETF::List) and not tail.term.improper?)
      tail = random_erlang_etf_term(size / 2, depth - 1, strict: strict)
    end
    term = Erlang::List[*(elements.map { |element| Erlang.from(element) })] + Erlang.from(tail)
    return Erlang::ETF::List[term] if strict == false
    return Erlang::ETF::List[term, elements, tail]
  end

  def erlang_etf_map(size = self.size, depth = 0, strict: false, &block)
    arity = size
    pairs = if block_given?
      arity.times.map(&block)
    else
      arity.times.map { [random_erlang_etf_term(size / 2, depth - 1, strict: strict), random_erlang_etf_term(size / 2, depth - 1, strict: strict)] }
    end
    pairs = pairs.flat_map { |pair| pair }
    term = Erlang::Map[*pairs]
    return Erlang::ETF::Map[term] if strict == false
    return Erlang::ETF::Map[term, pairs]
  end

  def erlang_etf_new_float(strict: false)
    float_string = nil
    float_object = nil
    while float_string.nil? or float_object.to_s.include?("Infinity")
      e = range(-323, 308)
      sign = (range(0, 1) == 0) ? '' : '-'
      integer = range(0, 9)
      fractional = Array.new(20); 20.times { |i| fractional[i] = range(0, 9) }
      float_string = "#{sign}#{integer}.#{fractional.join}e#{(e >= 0) ? '+' : ''}#{e}"
      float_object = ::BigDecimal.new(::BigDecimal.new(float_string).to_s).to_f
    end
    float = Erlang::Float[float_string]
    return Erlang::ETF::NewFloat[float]
  end

  def erlang_etf_new_reference(size = self.size, strict: false, &block)
    node, creation, ids = if block_given?
      instance_exec(&block)
    else
      [
        random_erlang_etf_atom(range(0, size & 0xff), strict: strict),
        range(0, size & 0x3),
        range(1, 3).times.map { range(0, size & 0xffff) }
      ]
    end
    term = Erlang::Reference[Erlang.from(node), creation, ids]
    return Erlang::ETF::NewReference[term] if strict == false
    return Erlang::ETF::NewReference[term, node, creation, ids]
  end

  def erlang_etf_nil(strict: false)
    return Erlang::ETF::Nil[Erlang::Nil]
  end

  def erlang_etf_pid(size = self.size, strict: false, &block)
    node, id, serial, creation = if block_given?
      instance_exec(&block)
    else
      [
        random_erlang_etf_atom(range(0, size & 0xff), strict: strict),
        range(0, size & 0x7fff),
        range(0, size & 0x1fff),
        range(0, size & 0x3)
      ]
    end
    term = Erlang::Pid[Erlang.from(node), id, serial, creation]
    return Erlang::ETF::Pid[term] if strict == false
    return Erlang::ETF::Pid[term, node, id, serial, creation]
  end

  def erlang_etf_port(size = self.size, strict: false, &block)
    node, id, creation = if block_given?
      instance_exec(&block)
    else
      [
        random_erlang_etf_atom(range(0, size & 0xff), strict: strict),
        range(0, size & 0xfffffff),
        range(0, size & 0x3)
      ]
    end
    term = Erlang::Port[Erlang.from(node), id, creation]
    return Erlang::ETF::Port[term] if strict == false
    return Erlang::ETF::Port[term, node, id, creation]
  end

  def erlang_etf_reference(size = self.size, strict: false, &block)
    node, id, creation = if block_given?
      instance_exec(&block)
    else
      [
        random_erlang_etf_atom(range(0, size & 0xff), strict: strict),
        range(0, size & 0xffff),
        range(0, size & 0x3)
      ]
    end
    term = Erlang::Reference[Erlang.from(node), creation, id]
    return Erlang::ETF::Reference[term] if strict == false
    return Erlang::ETF::Reference[term, node, id, creation]
  end

  def erlang_etf_small_atom(size = self.size, strict: false)
    len = (size > 255) ? 255 : size
    return Erlang::ETF::SmallAtom[Erlang::Atom[random_string(len)]]
  end

  def erlang_etf_small_atom_utf8(size = self.size, strict: false)
    len = (size > 255) ? 255 : size
    return Erlang::ETF::SmallAtomUTF8[Erlang::Atom[utf8_string(len), utf8: true]]
  end

  def erlang_etf_small_big(strict: false)
    integer = freq(
      [1, :range, ERLANG_ETF_SMALL_BIG_MIN, (-(1 << 31) + 1) - 1],
      [1, :range, (+(1 << 31) - 1) + 1, ERLANG_ETF_SMALL_BIG_MAX]
    )
    return Erlang::ETF::SmallBig[integer]
  end

  def erlang_etf_small_integer(strict: false)
    int = range(0, 255)
    return Erlang::ETF::SmallInteger[int]
  end

  def erlang_etf_small_tuple(size = self.size, depth = 0, strict: false, &block)
    arity = (size >= 256) ? 255 : size
    elements = if block_given?
      arity.times.map(&block)
    else
      arity.times.map { random_erlang_etf_term(size / 2, depth - 1, strict: strict) }
    end
    term = Erlang::Tuple[*(elements.map { |element| Erlang.from(element) })]
    return Erlang::ETF::SmallTuple[term] if strict == false
    return Erlang::ETF::SmallTuple[term, elements]
  end

  def erlang_etf_string(size = self.size, strict: false)
    return Erlang::ETF::String[Erlang::String[random_string(size)]]
  end

  def gen_large_big
    n = freq(
      [10, :range,   0,  255],
      [ 1, :range, 256, 1024]
    )
    sign = choose(0, 1)
    string = random_little_endian_string(n)
    integer = Erlang::Binary.decode_unsigned(string, :little) * ((sign == 0) ? +1 : -1)
    return Erlang::ETF::LargeBig[integer]
  end

  # def gen_new_float
  #   infinity = (1.0 / 0.0)
  #   e = range(-323, 308)
  #   sign = (range(0, 1) == 0) ? '' : '-'
  #   integer = range(0, 9)
  #   fractional = Array.new(20); 20.times { |i| fractional[i] = range(0, 9) }
  #   float_string = "#{sign}#{integer}.#{fractional.join}e#{(e >= 0) ? '+' : ''}#{e}"
  #   big_decimal = BigDecimal.new(float_string)
  #   float = big_decimal.to_f
  #   return gen_new_float if float == infinity or float == -infinity
  #   return Erlang::ETF::NewFloat[float]
  # end

  def gen_small_big
    n = range(0, 255)
    sign = choose(0, 1)
    string = random_little_endian_string(n)
    integer = Erlang::Binary.decode_unsigned(string, :little) * ((sign == 0) ? +1 : -1)
    return Erlang::ETF::SmallBig[integer]
  end

  def random_erlang_etf_atom(size = self.size, strict: false)
    return freq(
      [1, :erlang_etf_atom, size, strict: strict],
      [1, :erlang_etf_atom_utf8, size, strict: strict],
      [1, :erlang_etf_small_atom, size, strict: strict],
      [1, :erlang_etf_small_atom_utf8, size, strict: strict]
    )
  end

  def random_erlang_etf_bitstring(size = self.size, bits = self.range(1, 8), strict: false)
    return freq(
      [1, :erlang_etf_binary, size, strict: strict],
      [1, :erlang_etf_bit_binary, size, bits, strict: strict]
    )
  end

  def random_erlang_etf_integer(strict: false)
    return freq(
      [10, :erlang_etf_small_integer, strict: strict],
      [10, :erlang_etf_integer, strict: strict],
      [ 2, :erlang_etf_small_big, strict: strict],
      [ 1, :erlang_etf_large_big, strict: strict]
    )
  end

  def random_erlang_etf_list(size = self.size, depth = 0, strict: false, &block)
    return freq(
      [5, ->(gen) { gen.erlang_etf_list(size, depth, strict: strict, &block) }],
      [1, ->(gen) { gen.erlang_etf_list_improper(size, depth, strict: strict, &block) }]
    )
  end

  def random_erlang_etf_tuple(size = self.size, depth = 0, strict: false)
    return freq(
      [10, :erlang_etf_small_tuple, size, depth, strict: strict],
      [ 1, :erlang_etf_large_tuple, size, depth, strict: strict]
    )
    # return freq(
    #   [10, ->(gen) { gen.erlang_etf_small_tuple(size, depth, strict: strict, &block) }],
    #   [ 1, ->(gen) { gen.erlang_etf_large_tuple(size, depth, strict: strict, &block) }]
    # )
  end

  def random_erlang_etf_term(size = self.size, depth = 1, strict: false)
    if depth <= 0
      return freq(
        [1, :random_erlang_etf_atom, size, strict: strict],
        [1, :random_erlang_etf_bitstring, size, strict: strict],
        [1, :erlang_etf_export, size, strict: strict],
        [1, :erlang_etf_float, strict: strict],
        [1, :random_erlang_etf_integer, strict: strict],
        [1, :erlang_etf_new_float, strict: strict],
        [1, :erlang_etf_new_reference, size, strict: strict],
        [1, :erlang_etf_nil, strict: strict],
        [1, :erlang_etf_pid, size, strict: strict],
        [1, :erlang_etf_port, size, strict: strict],
        [1, :erlang_etf_reference, size, strict: strict],
        [1, :erlang_etf_string, size, strict: strict]
      )
    else
      return freq(
        [1, :random_erlang_etf_atom, size, strict: strict],
        [1, :random_erlang_etf_bitstring, size, strict: strict],
        [1, :erlang_etf_export, size, strict: strict],
        [1, :erlang_etf_float, strict: strict],
        [1, :random_erlang_etf_integer, strict: strict],
        [1, :random_erlang_etf_list, size, depth, strict: strict],
        [1, :erlang_etf_map, size, depth, strict: strict],
        [1, :erlang_etf_new_float, strict: strict],
        [1, :erlang_etf_new_reference, size, strict: strict],
        [1, :erlang_etf_nil, strict: strict],
        [1, :erlang_etf_pid, size, strict: strict],
        [1, :erlang_etf_port, size, strict: strict],
        [1, :erlang_etf_reference, size, strict: strict],
        [1, :erlang_etf_string, size, strict: strict],
        [1, :random_erlang_etf_tuple, size, depth, strict: strict]
      )
    end
  end

  def random_little_endian_string(size = self.size, bytes = nil)
    bytes ||= SecureRandom.random_bytes(size)
    loop do
      bytes.gsub!(/\x00*\z/, '')
      break if bytes.bytesize == size
      if bytes.bytesize < size
        bytes += SecureRandom.random_bytes(size - bytes.bytesize)
      end
    end
    return bytes
  end

  def random_string(size = self.size)
    bytes = SecureRandom.random_bytes(size)
    _, bytes = Erlang::Terms.utf8_encoding(bytes)
    return bytes
  end

  def utf8_string(size = self.size, bytes = nil)
    bytes ||= SecureRandom.random_bytes(size).force_encoding(UTF8_ENCODING)
    loop do
      break if bytes.valid_encoding?
      bytes = bytes.chars.select(&:valid_encoding?).join
      if bytes.bytesize < size
        bytes += SecureRandom.random_bytes(size - bytes.bytesize).force_encoding(UTF8_ENCODING)
      end
    end
    return bytes
  end

end
