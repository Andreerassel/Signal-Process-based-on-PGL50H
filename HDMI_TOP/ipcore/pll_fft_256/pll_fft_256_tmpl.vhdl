-- Created by IP Generator (Version 2022.1 build 99559)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT pll_fft_256
  PORT (
    clkin1 : IN STD_LOGIC;
    clkout0_2pad_gate : IN STD_LOGIC;
    pll_lock : OUT STD_LOGIC;
    clkout0_2pad : OUT STD_LOGIC;
    clkout2 : OUT STD_LOGIC;
    clkout3 : OUT STD_LOGIC
  );
END COMPONENT;


the_instance_name : pll_fft_256
  PORT MAP (
    clkin1 => clkin1,
    clkout0_2pad_gate => clkout0_2pad_gate,
    pll_lock => pll_lock,
    clkout0_2pad => clkout0_2pad,
    clkout2 => clkout2,
    clkout3 => clkout3
  );
