-- File name:   state_filter_in.vhd
-- Created:     2009-03-30
-- Author:      Jevin Sweval
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: Rijndael state filter for subblock inputs

use work.aes.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_filter_in is
   
   port (
      s              : in state_type;
      subblock       : in subblock_type;
      round_key      : in key_type;
      i              : in g_index;
      d_out          : out slice;
      filtered_key   : out byte
   );
   
end entity state_filter_in;


architecture behavioral of state_filter_in is
   
begin
   
   process(i, subblock, s, round_key)
      variable r, c : index;
      variable i_clamped : index;
   begin
      -- by default output dont cares
      for j in index loop
         d_out(j) <= (others => '0');
      end loop;
      
      i_clamped := to_integer(to_unsigned(i, 2));
      r := i_clamped;
      c := i / 4;
      
      d_out(0) <= s(r, c);
      filtered_key <= round_key(r, c);
      
      case subblock is
         when sub_bytes =>
            -- output the indexed byte
            d_out(0) <= s(r, c);
         when shift_rows =>
            -- output the indexed row
            for j in index loop
               d_out(j) <= s(i_clamped, j);
            end loop;
         when mix_columns =>
            -- output the indexed column
            for j in index loop
               d_out(j) <= s(j, i_clamped);
            end loop;
         when add_round_key =>
            -- output the indexed byte
            d_out(0) <= s(r, c);
            filtered_key <= round_key(r, c);
         when store_ct =>
            d_out(0) <= s(r, c);
         when others =>
            -- dont care - already done at the top
      end case;
   end process;
   
end architecture behavioral;

