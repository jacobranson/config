{
  # This is the merged library containing your namespaced library as well as all libraries from
  # your flake's inputs.
  lib,

  # Your flake inputs are also available.
  inputs,

  # The namespace used for your flake, defaulting to "internal" if not set.
  namespace,

  # Additionally, Snowfall Lib's own inputs are passed. You probably don't need to use this!
  snowfall-inputs,
}:

# Shorthands for mkOption functions.

with builtins;
with lib;

rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  mkStrOpt = mkOpt types.str;

  mkStrOpt' = mkOpt' types.str;
}
