#!/usr/bin/bash

main ()
{
  source ~/.bashrc.d/pointer.sh
  get_display_dimensions;

  wmp -a $(( RES_X - 10 )) 20;
}
main "$@"