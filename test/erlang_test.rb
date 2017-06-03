# encoding: utf-8

require 'test_helper'

class ErlangTest < Minitest::Test

  def test_binary_to_term_without_magic_byte
    assert_raises(NotImplementedError) { Erlang.binary_to_term("") }
  end

  def test_term_to_binary_when_term_cannot_evolve
    assert_raises(ArgumentError) { Erlang.term_to_binary(Object.new) }
  end

  def test_roundtrip
    ROUNDTRIP_TERMS.each_with_index do |term, i|
      lhs = Erlang.from(term)
      # lhs = Erlang.from(term) if term.kind_of?(Erlang::ETF::Term)
      rhs = Erlang.binary_to_term(Erlang.term_to_binary(term))
      assert_equal lhs, rhs, "expected #{lhs.inspect} after roundtrip, but was: #{rhs.inspect}"
      # COMPRESSION_MODES.each do |compression|
      #   rhs = Erlang.binary_to_term(Erlang.term_to_binary(term, compressed: compression))
      #   assert_equal lhs, rhs, "expected #{lhs.inspect} after roundtrip with {compressed: #{compression.inspect}}, but was: #{rhs.inspect}"
      # end
    end
  end

  # def test_property_of_roundtrip
  #   property_of {
  #     etf = random_erlang_etf_term
  #     term = etf.__erlang_term__
  #     [
  #       etf,
  #       term
  #     ]
  #   }.check { |(etf, term)|
  #     begin
  #     lhs = term
  #     rhs = Erlang.binary_to_term(Erlang.term_to_binary(etf))
  #     assert_equal lhs, rhs, "expected #{lhs.inspect} after roundtrip, but was: #{rhs.inspect}"
  #     rhs = Erlang.binary_to_term(Erlang.term_to_binary(term))
  #     assert_equal lhs, rhs, "expected #{lhs.inspect} after roundtrip, but was: #{rhs.inspect}"
  #     rescue => e
  #       binding.pry
  #       raise e
  #     end
  #   }
  # end

  ROUNDTRIP_TERMS = [
    # ATOM_EXT
    Erlang::Atom["\xCD" * 256],
    # ATOM_UTF8_EXT
    Erlang::Atom['Ω' * 256],
    # BINARY_EXT
    'a',
    'Ω',
    Erlang::Binary["Ω\xCD"],
    Erlang::Binary['a', 65, [[66]], Erlang::List[67], Erlang::Binary['z']],
    # BIT_BINARY_EXT
    Erlang::Bitstring['a', 255, bits: 7],
    Erlang::Bitstring['Ω', 255, bits: 7],
    Erlang::Bitstring["Ω\xCD", 255, bits: 7],
    # EXPORT_EXT
    Erlang::Export[:erlang, :now, 0],
    # FLOAT_EXT
    BigDecimal.new('1'),
    # FUN_EXT
    Erlang::Function[
      pid: Erlang::Pid[:"nonode@nohost", 38, 0, 0],
      mod: :erl_eval,
      index: 20,
      uniq: 95849314,
      free_vars: Erlang::List[
        Erlang::List[
          Erlang::Tuple[
            :B,
            Erlang::Binary[131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0]
          ],
          Erlang::Tuple[
            :L,
            Erlang::String[131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0]
          ],
          Erlang::Tuple[
            :R,
            Erlang::Reference[:"nonode@nohost", 0, [122, 0, 0]]
          ]
        ],
        Erlang::List[
          Erlang::Tuple[
            :clause,
            1,
            Erlang::Nil,
            Erlang::Nil,
            Erlang::List[Erlang::Tuple[:integer, 1, 1]]
          ]
        ],
        Erlang::Tuple[
          :eval,
          Erlang::Tuple[:shell, :local_func],
          Erlang::List[Erlang::Pid[:"nonode@nohost", 22, 0, 0]]
        ]
      ]
    ],
    # INTEGER_EXT
    -(1 << 31) + 1,
    +(1 << 31) - 1,
    # LARGE_BIG_EXT
    (-1 << (256 * 8)) + 1,
    (+1 << (256 * 8)) - 1,
    # LARGE_TUPLE_EXT
    Erlang::Tuple.new([Erlang::Nil] * 256),
    # LIST_EXT
    [:a],
    [:a, 1],
    [[:a, 1], [:b, 2]],
    Erlang::List[:a],
    Erlang::List[:a, :b],
    Erlang::List[:a].append(:b),
    (Erlang::List[:a] + :b),
    # MAP_EXT
    {},
    {:a => 1},
    {:a => 1, :b => 2},
    {a: {b: 1}},
    Erlang::Map[],
    Erlang::Map[:atom, 1],
    Erlang::Map[Erlang::Map[:atom, 1], 2],
    # NEW_FLOAT_EXT
    1.0,
    # NEW_FUN_EXT
    Erlang::Function[
      arity: 0,
      uniq: "c>yRz_\xF6\xED?Hv(\x04\x19\x102",
      index: 20,
      mod: :erl_eval,
      old_index: 20,
      old_uniq: 52032458,
      pid: Erlang::Pid[:"nonode@nohost", 79, 0, 0],
      free_vars: Erlang::List[
        Erlang::Tuple[
          Erlang::Nil,
          :none,
          :none,
          Erlang::List[
            Erlang::Tuple[
              :clause,
              27,
              Erlang::Nil,
              Erlang::Nil,
              Erlang::List[Erlang::Tuple[:atom, 0, :ok]]
            ]
          ]
        ]
      ]
    ],
    # NEW_REFERENCE_EXT
    Erlang::Reference[:'nonode@nohost', 0, [1, 0, 0]],
    # NIL_EXT
    [],
    Erlang::List[],
    Erlang::Nil,
    # PID_EXT
    Erlang::Pid[:'nonode@nohost', 100, 10, 1],
    # PORT_EXT
    Erlang::Port[:'nonode@nohost', 100, 1],
    # REFERENCE_EXT
    Erlang::Reference[:'nonode@nohost', 0, 1],
    # SMALL_ATOM_EXT
    :a,
    Erlang::Atom['a'],
    Erlang::Atom["Ω\xCD"],
    # SMALL_ATOM_UTF8_EXT
    :Ω,
    Erlang::Atom['Ω'],
    # SMALL_BIG_EXT
    (-1 << (255 * 8)) + 1,
    (+1 << (255 * 8)) - 1,
    # SMALL_INTEGER_EXT
    0,
    1,
    255,
    # SMALL_TUPLE_EXT
    Erlang::Tuple[],
    Erlang::Tuple[:a],
    Erlang::Tuple[:a, :b],
    Erlang::Tuple[Erlang::Tuple[:a, 1], Erlang::Tuple[:b, 2]],
    Erlang::Tuple[:bert, :unknown],
    Erlang::Tuple[:bert, 'bad value'],
    Erlang::Tuple[:bert, :dict, :invalid],
    Erlang::Tuple[:bert, :dict],
    Erlang::Tuple[:bert, :dict, Erlang::Tuple[:a]],
    # STRING_EXT
    Erlang::String['a'],
    Erlang::String['Ω'],
    Erlang::String["Ω\xCD"],
    # # BERT
    # Time.at(1363190400, 31388),
    # Erlang::Tuple[:bert, :time],
    # Erlang::Tuple[:bert, :time, 1, 1],
    # Erlang::Tuple[:bert, :time, 1, 1, 1, 1],
    # /^c(a)t$/imx,
    # Erlang::Tuple[:bert, :regex, '.', 'invalid'],
    # Erlang::Tuple[:bert, :regex],
    # Erlang::Tuple[:bert, *([0] * 256)],
    # Ruby
    false,
    nil,
    true
  ].freeze

  COMPRESSION_MODES = [
    false,
    true,
    *Erlang::ETF::Compressed::LEVEL_RANGE
  ].freeze

end
