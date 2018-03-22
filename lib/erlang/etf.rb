require 'erlang/etf/version'

require 'erlang/terms'

require 'erlang/etf/term'

require 'erlang/etf/atom'
require 'erlang/etf/atom_utf8'
require 'erlang/etf/binary'
require 'erlang/etf/bit_binary'
require 'erlang/etf/compressed'
require 'erlang/etf/export'
require 'erlang/etf/float'
require 'erlang/etf/fun'
require 'erlang/etf/integer'
require 'erlang/etf/large_big'
require 'erlang/etf/large_tuple'
require 'erlang/etf/list'
require 'erlang/etf/map'
require 'erlang/etf/new_float'
require 'erlang/etf/new_fun'
require 'erlang/etf/new_reference'
require 'erlang/etf/nil'
require 'erlang/etf/pid'
require 'erlang/etf/port'
require 'erlang/etf/reference'
require 'erlang/etf/small_atom'
require 'erlang/etf/small_atom_utf8'
require 'erlang/etf/small_big'
require 'erlang/etf/small_integer'
require 'erlang/etf/small_tuple'
require 'erlang/etf/string'

module Erlang
  module ETF
    # @private
    B2T = ::Hash[*[
      [ Erlang::ETF::Term::SMALL_INTEGER_EXT,   Erlang::ETF::SmallInteger  ],
      [ Erlang::ETF::Term::INTEGER_EXT,         Erlang::ETF::Integer       ],
      [ Erlang::ETF::Term::FLOAT_EXT,           Erlang::ETF::Float         ],
      [ Erlang::ETF::Term::ATOM_EXT,            Erlang::ETF::Atom          ],
      [ Erlang::ETF::Term::REFERENCE_EXT,       Erlang::ETF::Reference     ],
      [ Erlang::ETF::Term::PORT_EXT,            Erlang::ETF::Port          ],
      [ Erlang::ETF::Term::PID_EXT,             Erlang::ETF::Pid           ],
      [ Erlang::ETF::Term::SMALL_TUPLE_EXT,     Erlang::ETF::SmallTuple    ],
      [ Erlang::ETF::Term::LARGE_TUPLE_EXT,     Erlang::ETF::LargeTuple    ],
      [ Erlang::ETF::Term::NIL_EXT,             Erlang::ETF::Nil           ],
      [ Erlang::ETF::Term::STRING_EXT,          Erlang::ETF::String        ],
      [ Erlang::ETF::Term::LIST_EXT,            Erlang::ETF::List          ],
      [ Erlang::ETF::Term::BINARY_EXT,          Erlang::ETF::Binary        ],
      [ Erlang::ETF::Term::SMALL_BIG_EXT,       Erlang::ETF::SmallBig      ],
      [ Erlang::ETF::Term::LARGE_BIG_EXT,       Erlang::ETF::LargeBig      ],
      [ Erlang::ETF::Term::NEW_REFERENCE_EXT,   Erlang::ETF::NewReference  ],
      [ Erlang::ETF::Term::SMALL_ATOM_EXT,      Erlang::ETF::SmallAtom     ],
      [ Erlang::ETF::Term::FUN_EXT,             Erlang::ETF::Fun           ],
      [ Erlang::ETF::Term::NEW_FUN_EXT,         Erlang::ETF::NewFun        ],
      [ Erlang::ETF::Term::EXPORT_EXT,          Erlang::ETF::Export        ],
      [ Erlang::ETF::Term::BIT_BINARY_EXT,      Erlang::ETF::BitBinary     ],
      [ Erlang::ETF::Term::NEW_FLOAT_EXT,       Erlang::ETF::NewFloat      ],
      [ Erlang::ETF::Term::ATOM_UTF8_EXT,       Erlang::ETF::AtomUTF8      ],
      [ Erlang::ETF::Term::SMALL_ATOM_UTF8_EXT, Erlang::ETF::SmallAtomUTF8 ],
      [ Erlang::ETF::Term::MAP_EXT,             Erlang::ETF::Map           ],
      # [ Erlang::ETF::Term::DIST_HEADER,             NotImplementedError  ],
      # [ Erlang::ETF::Term::ATOM_CACHE_REF,          NotImplementedError  ],
      # [ Erlang::ETF::Term::ATOM_INTERNAL_REF2,      NotImplementedError  ],
      # [ Erlang::ETF::Term::ATOM_INTERNAL_REF3,      NotImplementedError  ],
      # [ Erlang::ETF::Term::BINARY_INTERNAL_REF,     NotImplementedError  ],
      # [ Erlang::ETF::Term::BIT_BINARY_INTERNAL_REF, NotImplementedError  ],
      [ Erlang::ETF::Term::COMPRESSED,          Erlang::ETF::Compressed    ]
    ].flatten].freeze

    # @private
    T2B = B2T.invert.freeze

    # @private
    TYPE = ::Hash[*[
      [ :atom,            Erlang::ETF::Atom          ],
      [ :atom_utf8,       Erlang::ETF::AtomUTF8      ],
      [ :binary,          Erlang::ETF::Binary        ],
      [ :bit_binary,      Erlang::ETF::BitBinary     ],
      [ :export,          Erlang::ETF::Export        ],
      [ :float,           Erlang::ETF::Float         ],
      [ :fun,             Erlang::ETF::Fun           ],
      [ :integer,         Erlang::ETF::Integer       ],
      [ :large_big,       Erlang::ETF::LargeBig      ],
      [ :large_tuple,     Erlang::ETF::LargeTuple    ],
      [ :list,            Erlang::ETF::List          ],
      [ :map,             Erlang::ETF::Map           ],
      [ :new_float,       Erlang::ETF::NewFloat      ],
      [ :new_fun,         Erlang::ETF::NewFun        ],
      [ :new_reference,   Erlang::ETF::NewReference  ],
      [ :nil,             Erlang::ETF::Nil           ],
      [ :pid,             Erlang::ETF::Pid           ],
      [ :port,            Erlang::ETF::Port          ],
      [ :reference,       Erlang::ETF::Reference     ],
      [ :small_atom,      Erlang::ETF::SmallAtom     ],
      [ :small_atom_utf8, Erlang::ETF::SmallAtomUTF8 ],
      [ :small_big,       Erlang::ETF::SmallBig      ],
      [ :small_integer,   Erlang::ETF::SmallInteger  ],
      [ :small_tuple,     Erlang::ETF::SmallTuple    ],
      [ :string,          Erlang::ETF::String        ]
    ].flatten].freeze

    def self.is_atom(term)
      return true if term.kind_of?(TYPE[:atom])
      return true if Erlang.is_atom(term) and term.size >= 256 and term.utf8 == false
      return false
    end

    def self.is_atom_utf8(term)
      return true if term.kind_of?(TYPE[:atom_utf8])
      return true if Erlang.is_atom(term) and term.size >= 256 and term.utf8 == true
      return false
    end

    def self.is_binary(term)
      return true if term.kind_of?(TYPE[:binary])
      return true if Erlang.is_binary(term)
      return false
    end

    def self.is_bit_binary(term)
      return true if term.kind_of?(TYPE[:bit_binary])
      return true if not Erlang.is_binary(term) and Erlang.is_bitstring(term)
      return false
    end

    def self.is_export(term)
      return true if term.kind_of?(TYPE[:export])
      return true if Erlang.is_function(term) and term.kind_of?(Erlang::Export)
      return false
    end

    def self.is_float(term)
      return true if term.kind_of?(TYPE[:float])
      return true if Erlang.is_float(term) and term.old == true
      return false
    end

    def self.is_fun(term)
      return true if term.kind_of?(TYPE[:fun])
      return true if Erlang.is_function(term) and not is_export(term) and not term.new_function?
      return false
    end

    def self.is_integer(term)
      return true if term.kind_of?(TYPE[:integer])
      return true if Erlang.is_integer(term) and not is_small_integer(term) and term >= (-(1 << 31) + 1) and term <= (+(1 << 31) - 1)
      return false
    end

    def self.is_large_big(term)
      return true if term.kind_of?(TYPE[:large_big])
      return true if Erlang.is_integer(term) and not is_small_integer(term) and not is_integer(term) and not is_small_big(term)
      return false
    end

    def self.is_large_tuple(term)
      return true if term.kind_of?(TYPE[:large_tuple])
      return true if Erlang.is_tuple(term) and not is_small_tuple(term)
      return false
    end

    def self.is_list(term)
      return true if term.kind_of?(TYPE[:list])
      return true if Erlang.is_list(term) and not is_nil(term) and not is_string(term)
      return false
    end

    def self.is_map(term)
      return true if term.kind_of?(TYPE[:map])
      return true if Erlang.is_map(term)
      return false
    end

    def self.is_new_float(term)
      return true if term.kind_of?(TYPE[:new_float])
      return true if Erlang.is_float(term) and term.old == false
      return false
    end

    def self.is_new_fun(term)
      return true if term.kind_of?(TYPE[:new_fun])
      return true if Erlang.is_function(term) and not is_export(term) and term.new_function?
      return false
    end

    def self.is_new_reference(term)
      return true if term.kind_of?(TYPE[:new_reference])
      return true if Erlang.is_reference(term) and term.new_reference?
      return false
    end

    def self.is_nil(term)
      return true if term.kind_of?(TYPE[:nil])
      return true if Erlang.is_list(term) and term.empty?
      return false
    end

    def self.is_pid(term)
      return true if term.kind_of?(TYPE[:pid])
      return true if Erlang.is_pid(term)
      return false
    end

    def self.is_port(term)
      return true if term.kind_of?(TYPE[:port])
      return true if Erlang.is_port(term)
      return false
    end

    def self.is_reference(term)
      return true if term.kind_of?(TYPE[:reference])
      return true if Erlang.is_reference(term) and not term.new_reference?
      return false
    end

    def self.is_small_atom(term)
      return true if term.kind_of?(TYPE[:small_atom])
      return true if Erlang.is_atom(term) and term.size < 256 and term.utf8 == false
      return false
    end

    def self.is_small_atom_utf8(term)
      return true if term.kind_of?(TYPE[:small_atom_utf8])
      return true if Erlang.is_atom(term) and term.size < 256 and term.utf8 == true
      return false
    end

    def self.is_small_big(term)
      return true if term.kind_of?(TYPE[:small_big])
      return true if Erlang.is_integer(term) and not is_small_integer(term) and not is_integer(term) and intlog2div8(term) < 256
      return false
    end

    def self.is_small_integer(term)
      return true if term.kind_of?(TYPE[:small_integer])
      return true if Erlang.is_integer(term) and term >= 0 and term <= (+(1 << 8) - 1)
      return false
    end

    def self.is_small_tuple(term)
      return true if term.kind_of?(TYPE[:small_tuple])
      return true if Erlang.is_tuple(term) and term.arity < 256
      return false
    end

    def self.is_string(term)
      return true if term.kind_of?(TYPE[:string])
      return true if Erlang.is_list(term) and not is_nil(term) and term.kind_of?(Erlang::String) and term.length < (+(1 << 16) - 1)
      return false
    end

    # @private
    def self.intlog2(x)
      raise ArgumentError, "x must be a positive Integer" if not x.is_a?(::Integer) or x < 1
      r = 0
      loop do
        break if x == 0
        x >>= 1
        r += 1
      end
      return r
    end

    # @private
    def self.intlog2div8(x)
      raise ArgumentError, "x must be a non-negative Integer" if not x.is_a?(::Integer)
      x = x.abs if x < 0
      return 1 if x == 0
      x = intlog2(x)
      return 1 + ((x - 1).div(8))
    end

    # @private
    def self.binary_to_term(buffer, etf)
      magic = buffer.readchar
      if magic == Erlang::ETF::Term::ERLANG_MAGIC_BYTE
        term = nil
        begin
          term = read_term(buffer)
        rescue NotImplementedError => e
          buffer.ungetc(magic)
          raise e
        end
        return Erlang.from(term) if etf == false
        return term
      else
        buffer.ungetc(magic)
        raise ArgumentError, "unknown Erlang magic byte #{magic.inspect} (should be #{Erlang::ETF::Term::ERLANG_MAGIC_BYTE.inspect})"
      end
      # mzbuffer.read(1)
      # magic = buffer.read(1)
      # if magic == Erlang::ETF::Term::ERLANG_MAGIC_BYTE
      #   Terms.evolve(buffer)
      # else
      #   raise NotImplementedError, "unknown Erlang magic byte #{magic.inspect} (should be #{Erlang::ETF::Term::ERLANG_MAGIC_BYTE.inspect})"
      # end
    end

    # @private
    def self.read_term(buffer)
      tag = buffer.getbyte
      if B2T.key?(tag)
        return B2T[tag].erlang_load(buffer)
      else
        buffer.ungetbyte(tag)
        raise NotImplementedError, "unknown Erlang External Format tag #{tag.inspect} (see http://erlang.org/doc/apps/erts/erl_ext_dist.html)"
      end
    end

    # @private
    def self.term_to_binary(term, buffer, compressed)
      buffer << Erlang::ETF::Term::ERLANG_MAGIC_BYTE
      if compressed == false
        return term.erlang_dump(buffer)
      else
        return Erlang::ETF::Compressed[term, level: compressed].erlang_dump(buffer)
      end
    end

    # @private
    def self.write_term(term, buffer)
      term = Erlang.etf(term)
      return term.erlang_dump(buffer)
    end

  end

  def self.etf(term)
    return term.to_erlang_etf if term.respond_to?(:to_erlang_etf)
    return term if term.kind_of?(Erlang::ETF::Term)
    term = Erlang.from(term)
    return term.to_erlang_etf if term.respond_to?(:to_erlang_etf)
    type = external_type(term)
    constructor = Erlang::ETF::TYPE[type]
    raise NotImplementedError, "unsupported type #{type.inspect}" if constructor.nil?
    return term if term.kind_of?(constructor)
    return constructor[term]
  end

  def self.external_type(term)
    return term.erlang_external_type if term.respond_to?(:erlang_external_type)
    term = Erlang.from(term)
    return :atom            if Erlang::ETF.is_atom(term)
    return :atom_utf8       if Erlang::ETF.is_atom_utf8(term)
    return :binary          if Erlang::ETF.is_binary(term)
    return :bit_binary      if Erlang::ETF.is_bit_binary(term)
    return :export          if Erlang::ETF.is_export(term)
    return :float           if Erlang::ETF.is_float(term)
    return :fun             if Erlang::ETF.is_fun(term)
    return :integer         if Erlang::ETF.is_integer(term)
    return :large_big       if Erlang::ETF.is_large_big(term)
    return :large_tuple     if Erlang::ETF.is_large_tuple(term)
    return :list            if Erlang::ETF.is_list(term)
    return :map             if Erlang::ETF.is_map(term)
    return :new_float       if Erlang::ETF.is_new_float(term)
    return :new_fun         if Erlang::ETF.is_new_fun(term)
    return :new_reference   if Erlang::ETF.is_new_reference(term)
    return :nil             if Erlang::ETF.is_nil(term)
    return :pid             if Erlang::ETF.is_pid(term)
    return :port            if Erlang::ETF.is_port(term)
    return :reference       if Erlang::ETF.is_reference(term)
    return :small_atom      if Erlang::ETF.is_small_atom(term)
    return :small_atom_utf8 if Erlang::ETF.is_small_atom_utf8(term)
    return :small_big       if Erlang::ETF.is_small_big(term)
    return :small_integer   if Erlang::ETF.is_small_integer(term)
    return :small_tuple     if Erlang::ETF.is_small_tuple(term)
    return :string          if Erlang::ETF.is_string(term)
    raise NotImplementedError
  end

  def self.binary_to_term(buffer, etf: false)
    buffer = ::StringIO.new(Erlang::ETF::Term.binary_encoding(buffer)) if buffer.respond_to?(:force_encoding)
    return Erlang::ETF.binary_to_term(buffer, etf)
  end

  def self.term_to_binary(term, buffer: ::String.new, compressed: false)
    term = Erlang.etf(term)
    buffer = Erlang::ETF::Term.binary_encoding(buffer)
    return Erlang::ETF.term_to_binary(term, buffer, compressed)
  end

end
