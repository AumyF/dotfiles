import {
  Action,
  defineTask,
  prettyResult,
  Result,
} from "dotstingray/core/mod.ts";
import { link } from "dotstingray/utils/mod.ts";
import {
  iteratorFrom,
  wrapIterator,
} from "https://deno.land/x/iterator_helpers@v0.1.2/mod.ts";

const home = Deno.env.get("HOME");

if (!home) throw new Error("$HOME is not set");

const deploy = defineTask([
  link({
    source: "./starship/starship.toml",
    destination: `${home}/.config/starship.toml`,
  }),
  link({ source: "./git/config", destination: `${home}/.config/git/config` }),
  link({ source: "./git/ignore", destination: `${home}/.config/git/ignore` }),
  link({
    source: "./neovim/init.lua",
    destination: `${home}/.config/nvim/init.lua`,
  }),
  link({ source: "./zsh/rc.zsh", destination: `${home}/.zshrc` }),
  link({ source: "./zsh/env.zsh", destination: `${home}/.zshenv` }),
  link({
    source: "./direnv/rc.sh",
    destination: `${home}/.config/direnv/direnvrc`,
  }),
]);

const nixProfileInstall = (
  /** @example "nixpkgs#deno" */ pkg: string,
) =>
async () => {
  const process = Deno.run({
    cmd: ["nix", "profile", "install", pkg],
  });

  await process.status();
};

/** Useful for creating `stat` to check whether a command installed successfully */
const processSuceeds =
  (cmd: [string, ...string[]]): Action["check"] => async () => {
    let process;
    try {
      process = Deno.run({ cmd, stdout: "null", stderr: "piped" });
    } catch (e) {
      return { name: cmd[0], ok: false, message: e };
    }

    const status = await process.status();

    if (status.success) {
      return { name: cmd[0], ok: true };
    }

    const stderr = await process.stderrOutput().then((out) =>
      new TextDecoder().decode(out)
    );

    // TODO Ability to show full stderr
    const message = wrapIterator(iteratorFrom(stderr.split("\n")[0])).take(80)
      .reduce((acc, c) => acc + c, "");

    return { name: cmd[0], ok: false, message };
  };

const installCliByNix = (pkg: string, checkCommand: [string, ...string[]]) => ({
  run: nixProfileInstall(pkg),
  check: processSuceeds(checkCommand),
});

const setup = defineTask([
  installCliByNix("nixpkgs#neovim", ["nvim", "--version"]),
  installCliByNix("nixpkgs#helix", ["hx", "--version"]),
  installCliByNix("nixpkgs#bat", ["bat", "--version"]),
  installCliByNix("nixpkgs#direnv", ["direnv", "--version"]),
  installCliByNix("nixpkgs#fd", ["fd", "--version"]),
  installCliByNix("nixpkgs#fzf", ["fzf", "--version"]),
  installCliByNix("nixpkgs#gh", ["gh", "--version"]),
  installCliByNix("nixpkgs#ghq", ["ghq", "--version"]),
  installCliByNix("nixpkgs#git", ["git", "--version"]),
  installCliByNix("nixpkgs#httpie", ["httpie", "--version"]),
  installCliByNix("nixpkgs#lsd", ["lsd", "--version"]),
  installCliByNix("nixpkgs#mcfly", ["mcfly", "--version"]),
  installCliByNix("nixpkgs#ripgrep", ["rg", "--version"]),
  installCliByNix("nixpkgs#starship", ["starship", "--version"]),
  installCliByNix("nixpkgs#tealdeer", ["tldr", "--version"]),
  installCliByNix("nixpkgs#zellij", ["zellij", "--version"]),
  installCliByNix("nixpkgs#zoxide", ["zoxide", "--version"]),
]);

const printResults = (results: Result[]) => {
  for (const result of results.map((result) => prettyResult(result))) {
    console.log(result);
  }
};

if (Deno.args.includes("deploy")) {
  if (Deno.args.includes("run")) {
    await deploy.run();
  } else {
    printResults(await deploy.check());
  }
} else if (Deno.args.includes("setup")) {
  if (Deno.args.includes("run")) {
    await setup.run();
  } else {
    printResults(await setup.check());
  }
} else {
  console.log(`unknown commands: ${Deno.args}`);
  Deno.exit(1);
}
