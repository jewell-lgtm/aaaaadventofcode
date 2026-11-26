% Harness helpers, as static methods:
%   aoc.example()      true when running an example (aoc test)
%   aoc.arg('size', 71)  example-specific constant from examples.toml `args`, else the default
classdef aoc
  methods (Static)
    function tf = example()
      tf = strcmp(getenv('AOC_EXAMPLE'), '1');
    end

    function v = arg(name, default)
      raw = getenv('AOC_ARGS');
      args = [];
      if ~isempty(raw), args = jsondecode(raw); end
      if isstruct(args) && isfield(args, name)
        v = args.(name);
      else
        v = default;
      end
    end
  end
end
