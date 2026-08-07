# glew dependencies

|project|license [^_l]|description [dependencies]|version|source|diff [^_d]|
|-------|-------------|--------------------------|-------|------|----------|
|<a id='glew' />[glew](http://glew.sourceforge.net)|[MIT](https://github.com/nigels-com/glew/blob/master/LICENSE.txt 'Modified BSD, Mesa 3D (renamed X11/MIT), Khronos (renamed X11/MIT)')|The OpenGL Extension Wrangler Library [deps: _OpenGL_]| |[upstream](https://github.com/nigels-com/glew 'github.com/nigels-com/glew')|  [patch]|
|<a id='OpenGL' />[OpenGL](https://cmake.org/cmake/help/latest/module/FindOpenGL.html)|[SGI-OpenGL](https://spdx.org/licenses/SGI-OpenGL.html 'SGI OpenGL License')|Finds the OpenGL and OpenGL Utility Library (GLU)|[xpv1.0.1](https://github.com/externpro/OpenGL/releases/tag/xpv1.0.1 'release')|[repo](https://github.com/externpro/OpenGL 'github.com/externpro/OpenGL')|[diff](https://github.com/externpro/OpenGL/compare/v0...xpv1.0.1 'github.com/externpro/OpenGL/compare/v0...xpv1.0.1') [bin]|

![deps](xprodeps.svg 'dependencies')

Dependency version check: all 1 parent-manifest versions match pinned versions.

|diff  |description|
|------|-----------|
|patch |diff modifies/patches existing cmake|
|intro |diff introduces cmake|
|auto  |diff adds cmake to replace autotools/configure/make|
|native|diff adds cmake but uses existing build system|
|bin   |diff adds cmake to repackage binaries built elsewhere|
|fetch |diff adds cmake and utilizes FetchContent|

[^_l]: see [SPDX License List](https://spdx.org/licenses/ '') for a list of commonly found licenses
[^_d]: see table above with description of diff
