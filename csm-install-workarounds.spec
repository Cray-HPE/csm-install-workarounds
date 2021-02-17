# Copyright 2021 Hewlett Packard Enterprise Development LP
Name: csm-install-workarounds
License: MIT License
Summary: Workarounds necessary for the CSM product
Version: %(cat .version)
Release: %(echo ${BUILD_METADATA})
Source: %{name}-%{version}.tar.bz2
Vendor: Cray Inc.

%description
Installs workarounds necessary for the CSM product.

%prep
%setup -q

%build

%install
mkdir -vp ${RPM_BUILD_ROOT}/opt/cray/csm
cp -vr workarounds ${RPM_BUILD_ROOT}/opt/cray/csm

%pre

%clean

%files
%license LICENSE
%defattr(644,root,root)

/opt/cray/csm/workarounds

%changelog
