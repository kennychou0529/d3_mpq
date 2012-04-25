# README: http://www.d3inferno.com/Items.gam.html
module D3MPQ::CoreData::GameBalance
  class Items < Base
    self.struct_size = 0x590

    content do
      zeroes

      # Name
      string  :name,:length => 0x100, :trim_padding => true

      uint32  :sno_actor
      uint32  :type_hash

      # Flags
      bit1  :check_value => 0x0
      bit1  :is_easter_egg
      bit1  :is_nephalem_cube
      bit1  :bit_c2
      bit2  :check_value => 0x0
      bit1  :_f_01         # UniqueAmuletPvP && Co
      bit1  :is_uniq
      bit24 :check_value => 0x0


      zeroes

      uint32 :item_level

      zeroes :length => 0x2

      uint32 :random_properties_count
      uint32 :max_sockets
      uint32 :max_stack_amount
      uint32 :base_gold_value
      uint32 :ilvl2
      uint32 :required_level
      uint32 :durability_min
      uint32 :durability_delta
      uint32 :ref2
      uint32 :sno_base_item                       # baseItemHash
      uint32 :sno_set                             # setItemBonuses
      uint32 :sno_component_treasure_class        # salvageCommon
      uint32 :sno_component_treasure_class_rare   # salvageMagic
                                                  # salvageRare
      uint32 :sno_rare_name_prefix_string_list    # rareGroupPrefixId
                                                  # rareGroupSuffixId
      zeroes

      uint32  :u09 #town scroll etc.

      zeroes  :length => 0x18

      # Damage
      float_le  :weapong_damage_min
      float_le  :weapong_damage_delta
      zeroes    :length => 0x15

      # Armor
      float_le  :armor_minimum
      float_le  :armor_variable
      zeroes    :length => 0x2A

      # Speed
      float_le  :attacks_per_second
      zeroes    :length => 0x28

      # Unknown
      uint32    :u10    # Weapons:        30601 = wand; 30599 = bow/crossbow; 30592 = rest
                        # non-weapongs:   0xFF

      # Padding
      zeroes
      ffs
      zeroes
      ffs
      zeroes
      ffs
      zeroes  :length => 13

      # TODO
      uint32  :u21
      uint32  :u22
      zeroes  :length => 2

      # TODO: Convert attributes to array

      # Attributes / ModCodes

#0x00	DWord modCode;	// modCode (id)
#0x04	DWord modParam1;	// param used for elemental dmg and resists
#0x08	DWord modParam2;	// param
#0x0C	DWord modParam2;	// param
#0x10	DWord varDataOffset;	// variable data offset (from the start of the data section)
#0x14	DWord varDataLength;	// variable data length

        # Attribute 1
        uint32  :u31_offset
        uint32  :u31_length
        uint32  :u31_val1
        uint32  :u34_val2
        zeroes  :length => 2

        # Attribute 2-15
        14.times do |i|
          uint32  "attr#{i}_offset".intern  # offset
          uint32  "attr#{i}_length".intern  # val
          uint32  "attr#{i}_val".intern  # val
          ffs
          zeroes  :length => 2
        end

        # Attribute 16 (Recipes)
        uint32  :u41_offset
        uint32  :u41_length
        uint32  :u41_val1
        uint32  :u41_val2   # none 0 x FF FF FF FF if Recipe
        ffs     :length => 2


      ffs     :length => 4

      # Legendary Affixes
      uint32  :affix1_ref
      uint32  :affix2_ref
      uint32  :affix3_ref
      uint32  :affix4_ref
      uint32  :affix5_ref
      ffs
      uint32  :affix1_level
      uint32  :affix2_level
      uint32  :affix3_level
      uint32  :affix4_level
      uint32  :affix5_level

      zeroes
    end
  end
end

