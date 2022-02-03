{ pkgs }:

pkgs.writeShellScript "ormolu.sh" ''
  dir=$1
  mode=$2
  [[ -n $3 ]] && ext1="--ghc-opt $3" || ext1=""
  [[ -n $4 ]] && ext2="--ghc-opt $4" || ext2=""
  [[ -n $5 ]] && ext3="--ghc-opt $5" || ext3=""
  [[ -n $6 ]] && ext4="--ghc-opt $6" || ext4=""
  [[ -n $7 ]] && ext5="--ghc-opt $7" || ext5=""
  [[ -n $8 ]] && ext6="--ghc-opt $8" || ext6=""
  [[ -n $9 ]] && ext7="--ghc-opt $9" || ext7=""
  [[ -n ''${10} ]] && ext8="--ghc-opt ''${10}" || ext8=""
  [[ -n ''${11} ]] && ext9="--ghc-opt ''${11}" || ext9=""
  [[ -n ''${12} ]] && ext10="--ghc-opt ''${12}" || ext10=""

  find $dir -type d \( -name dist-newstyle -o -name stack-work \) -prune -false -o -name '*.hs' | xargs ${pkgs.ormolu}/bin/ormolu \
    --mode $mode \
    $ext1 \
    $ext2 \
    $ext3 \
    $ext4 \
    $ext5 \
    $ext6 \
    $ext7 \
    $ext8 \
    $ext9 \
    $ext10
''
