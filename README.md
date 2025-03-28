<div align="center">

# arcane

**A project made using create-roblox.**

</div>

## Getting Started

In order to start running your project, run `lune run dev`. This will start a Rojo server alongside Darklua (if applicable), so you can use string requires even when actively developing.
If you want to build your project, run `lune run build`. This will build your project into a `.rbxl` or `.rbxm` file, which can be used in Roblox Studio. Keep in mind that unless you include your models in the `src` folder, they will not be included in the build, and you will need to sync them manually.

Below, you can find a list of all the tools and libraries that are included in this project, and the links to relevant pages.


## [Selene](https://github.com/Kampfkarren/selene)

Selene is a Lua linter. It can be used in Visual Studio Code to give real-time feedback on your code if you have the [Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=Kampfkarren.selene-vscode) installed, or can be used in a CI workflow to ensure that your code is consistent and does not make common mistakes. In order to check your codebase, run `selene src` in your terminal. This will automatically check your code for common mistakes and inconsistencies.


## [StyLua](https://github.com/JohnnyMorganz/StyLua)

StyLua is a code formatter that can be used both in your editor and CI workflows. When enabled, it is automatically enabled in your editor, if you have the [Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) installed. In order to style your codebase without your editor, run `stylua src` in your terminal. This will automatically format your code to be consistent with the style guide.


## Zap

Zap is a networking solution for Roblox, creating code based on configuration done through it's own IDL. Documentation is available [here](https://zap.redblox.dev/), and an extension that adds syntax highlighting and autocomplete for the IDL is available [here](https://github.com/VirtualButFake/zap-vscode).


## Cmdr

Cmdr is a command console for Roblox games. With your installation, a "hello world" command was created as an example, and you can use it to get started. The guide is available [here](https://eryn.io/Cmdr/guide/Setup.html).


## [Wally](https://github.com/UpliftGames/wally)

Wally is a package manager for Roblox, created by Uplift Games. Some packages may be installed with your project by default. In order to add new packages, modify `wally.toml`. You can search for packages on [wally.run](https://wally.run/). If you wish to install the added packages, run `lune run install-packages` in your terminal. This will automatically export the types and rename the folder (if needed).


## [Darklua](https://darklua.com/)

Darklua is a tool for transforming Lua or Luau code. In this project, it is used to convert string requires into requires that the Roblox engine understands, removing unneccesary code and injecting global values into the code.


## Darklua String Requires

Through Darklua, string requires (such as `require("@packages/package")`) are converted into Roblox path-based requires. This allows for a more flexible and modular project structure, and allows for the use of modules in a more straightforward manner. To add new paths, add them in `.darklua.json` and make sure to add them in `.vscode/settings.json` as well so Luau LSP recognizes them.
