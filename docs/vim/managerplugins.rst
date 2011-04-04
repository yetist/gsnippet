=====================
有效的管理你的vim插件
=====================
:作者: yetist
:邮箱: yetist@gmail.com

.. contents:: 内容

传统的vim plugin使用方式
=========================

我们先来回顾一下传统的vim plugin 管理方式。

安装：
 要安装一个插件，首先要从网络上下载回来，然后解压、并放在~/.vim/下合适的目录中，如plugin、syntax、ftplugin等。

升级：
 经常使用的一些插件，可能需要过一段时间去vim.org上面看看有没有新的版本，如果有的话，使用和安装相同的方式来解压覆盖，从而完成更新工作。

卸载：
 相对于安装和更新，这个就比较麻烦了，尤其是你有太多的插件的话，你无法确定某个插件到底安装了哪些文件，最坏的情况下，你可能需要下载一个原始版本来做参考，然后从你的~/.vim/目录中把它们删除干净。

多台电脑保持同步：
 通常的方法是把原来的~/.vim目录做个备份，然后在需要的时候把它整个复制过去。时间长了，这会产生问题，如果两台电脑中都做了修改(分别安装了不同的插件或更新了某个插件)，这时将无法准确的保持同步。

从长期使用vim及对vim plugin的经历中，我感觉这是一种很费时费力且效率低下的工作。做个不太恰当的比喻，vim 插件的安装方式就像在windows下面安装软件一样，需要自己动手去网络上寻找到某个插件，手工完成它的安装、更新以及卸载工作。在多台电脑上同步，除了重复这个过程，就是选择互相复制的方式，效率极其低下。

高效的vim plugin使用方式
========================

解决这个问题最理想的方式是： 
 借鉴linux管理软件包的方式来管理vim的插件，只要知道插件的名字，通过运行一条命令就能自动进行安装、升级或卸载工作。更进一步的，应该能支持自己写给自己用的vim plugin,就像linux中第三方软件仓库一样，只要告诉系统这个插件的地址，就能使用相同的插件管理命令来管理。

这样做的好处显而易见的，提升了效率，另外个人认为vim用户的需求有时只是需要使用某个插件而已，并不需要关心这个插件应该放在plugin、syntax还是ftplugin目录中。

有解决方案还要有工具支持才行，这个工具就是 vim-addon-manager_ 。（看着眼熟？说明你是debian/ubuntu用户，因为debian上有个包就叫这个名字，但不是一回事）。

vim-addon-manager_ 的目标很KISS，就是管理vim plugin 的。 通过它可以在线安装vim.org 网站上的任何一个插件，只要运行一条命令即可，它会自动从vim.org 网站下载插件,并解压安装。它对每个插件使用不同的目录，这样卸载时只要删除那个插件的目录即可。这个插件不仅仅能支持vim.org上面已有的插件，还支持存放在其它地方的插件，不管是压缩包还是 SCM 形式，目前支持的SCM 包括git、svn、bzr等等。存放在其它地方的vim 插件需要联系作者来注册它，使它成为官方直接支持的插件。如果不做官方注册，你也可以像第三方源那样使用用，区别就是受众比较小，可能就你一个人用而已。

安装 vim-addon-manager_
-------------------------

vim-addon-manager_ 本身也是一个vim plugin, 所以首先要安装它。

.. code-block:: bash
  
  mv ~/.vim ~/vim
  mkdir ~/.vim
  mkdir ~/.vim/addons    [1]_
  cd ~/.vim/addons
  git clone git://github.com/MarcWeber/vim-addon-manager.git   [2]_
  git clone git://github.com/MarcWeber/vim-addon-manager-known-repositories.git   [3]_

在文件中加入以下内容

.. code-block:: vim
    
  fun SetupVAM()
    set runtimepath+=~/.vim/addons/vim-addon-manager  [4]_
    call vam#ActivateAddons([
  			  \ 'a.vim_-_Alternate_Files_quickly_.c',
  			  \ 'taglist',
  			  \ ])                        [5]_
  endf
  call SetupVAM()

.. [1] 创建一个保存vim addon的目录，如果愿意，也可以创建成这样 ~/vim-addon
.. [2] 在addons 目录中下载最新的vim-adon-manager 代码
.. [3] 在addons 目录中下载最新的vim-adon-manager-known-repositories 代码,这个插件包含了作者收集到的大量vim plugin 的注册信息
.. [4] 设置 vimruntimepath 路径，在指定的目录中需要有 vim-addon-manager_ 插件代码存在
.. [5] 在这里我们默认激活了两个vim 插件：a.vim 和 taglist

使用 vim-addon-manager_
-------------------------

现在 vim-addon-manager_ 已经安装好了, vim-addon-manager_ 管理vim plugin 使用这些命令:

InstallAddons {name} ...
        从网络安装指定的插件。
        通常情况下，应该使用ActivateAddons 命令直接激活。只有在需要了解插件包含的文件列表时才使用这个命令先安装，后激活。

ActivateAddons {name} ...
        激活指定的插件。
        如果插件没有安装，则先从网络下载安装，然后激活。

ActivateInstalledAddons {name} ...
        激活指定的插件
        指定的插件已经被安装，但没有激活。这个命令和ActivateAddons 命令的区别仅在于只补全已经安装的插件。

UpdateAddons [{name} ...]
        更新指定的插件到最新版本。
        如果没有参数则更新所所有已安装插件。

UninstallNotLoadedAddons {name} ...
        卸载指定的插件。

测试 vim-addon-manager_
^^^^^^^^^^^^^^^^^^^^^^^^^

1. 安装

   先安装一个最常用的插件taglist 和 a.vim
  
.. code-block:: vim
 
 :InstallAddons taglist
 :ActivateAddons taglist
 :ActivateAddons a.vim_-_Alternate_Files_quickly_.c

通过 InstallAddons 来安装taglist可以看到 taglist 包含的文件。
这两个文件都被安装到了前面设置的目录中了::

 /home/yetist/.vim/
 |-- addons
 |   |-- a.vim_-_Alternate_Files_quickly_.c
 |   |-- taglist
 |   |-- vim-addon-manager
 |   `-- vim-addon-manager-known-repositories
 `-- vimrc

2. 更新：

   更新taglist 到最新版本

.. code-block:: vim
 
 :UpdateAddons taglist

.. Note:: vim-addon-manager_ 和 vim-addon-manager-known-repositories_ 这两个插件也可以使用 UpdateAddons 命令来更新，更新时会自动调用 git pull 命令。

3. 测试

   测试一下taglist 插件

.. code-block:: vim
 
 :Tlist

4. 卸载

   卸载taglist 插件
 
.. code-block:: vim
 
 :UninstallNotLoadedAddons taglist

卸载之后taglist 插件被从addons 目录中删除了::

 /home/yetist/.vim/
 |-- addons
 |   |-- a.vim_-_Alternate_Files_quickly_.c
 |   |-- vim-addon-manager
 |   `-- vim-addon-manager-known-repositories
 `-- vimrc

.. Note:: 使用 ActivateAddons 命令激活的插件在下一次启动 vim 时，并不会自动激活，要想让每次使用vim 时都自动激活，需要修改 ~/.vimrc文件，把它加入到
    call vam#ActivateAddons() 的参数列表中。

使用 vim-addon-manager_ 自定义源
---------------------------------

凡是在 vim-addon-manager-known-repositories_ 中注册过的vim plugin 都可以直接使用，但是在一些情况下可能你需要使用没有被注册的 vim 插件，比如自己写的差不多只给自己用的插件，或者想一直使用某个插件的开发版本。

这种情况就属于使用 vim-addon-manager_ 的自定义源了，如果插件的开发版本支持 vim-addon-manager_ , 那么你只需要在 ~/.vimrc 文件中设置一个变量就行了。
比如 vimim 现在已经支持 vim-addon-manager_ 了，你需要做的就是加入下面这行内容在你的 ~/.vimrc 文件中：

.. code-block:: vim
 
 let g:vim_addon_manager['plugin_sources']['vimim'] = {"type":"svn", "url":"http://vimim.googlecode.com/svn/trunk"}

同时把"vimim" 加入到 call vam#ActivateAddons() 的参数列表中即可。

现在请把你之前的 vim 插件都整理一下吧，使用 vim-addon-manager_ 来管理。

记得开始我们说过多台电脑间的同步问题，现在看来，同步就很简单了，因为只要同步一个 ~/.vimrc 文件就够了。

.. _vim-addon-manager: https://github.com/MarcWeber/vim-addon-manager 
.. _vim-addon-manager-known-repositories: https://github.com/MarcWeber/vim-addon-manager-known-repositories
