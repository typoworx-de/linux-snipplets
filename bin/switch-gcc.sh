#!/bin/sh
GCC_VERSION=${GCC_VERSION:-9}

echo "Switching Compiler-Set to Version ${GCC_VERSION}"

for compiler in gcc cpp g++;
do
  [ $(update-alternatives --list ${compiler} | grep -c "${compiler}-${GCC_VERSION}") -eq 0 ] || {
    update-alternatives --install /usr/bin/${compiler} ${compiler} $(which ${compiler}-${GCC_VERSION}) ${GCC_VERSION}
  }

  update-alternatives --set ${compiler} /usr/bin/${compiler}-${GCC_VERSION} || exit 1
done

exit 0
