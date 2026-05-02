import type { Codemod, Edit } from "codemod:ast-grep";
import type TypeScript from "codemod:ast-grep/langs/typescript";

const SAFE_UTIL_REWRITES: Record<string, string> = {
  parseEther: "parseEther",
  parseUnits: "parseUnits",
  formatEther: "formatEther",
  formatUnits: "formatUnits",
  id: "id",
  getAddress: "getAddress",
  isAddress: "isAddress",
  keccak256: "keccak256",
};

function replaceAllMatches(
  rootNode: ReturnType<Parameters<Codemod<TypeScript>>[0]["root"]>,
  pattern: string,
  findText: string,
  replaceText: string,
): Edit[] {
  const matches = rootNode.findAll({
    rule: {
      pattern,
    },
  });

  return matches.map((match) => match.replace(match.text().replace(findText, replaceText)));
}

const codemod: Codemod<TypeScript> = async (root) => {
  const rootNode = root.root();
  const edits: Edit[] = [];

  for (const [fromName, toName] of Object.entries(SAFE_UTIL_REWRITES)) {
    edits.push(
      ...replaceAllMatches(
        rootNode,
        `ethers.utils.${fromName}($$$ARGS)`,
        `ethers.utils.${fromName}`,
        `ethers.${toName}`,
      ),
    );
  }

  edits.push(
    ...replaceAllMatches(
      rootNode,
      "new ethers.providers.JsonRpcProvider($$$ARGS)",
      "ethers.providers.JsonRpcProvider",
      "ethers.JsonRpcProvider",
    ),
  );

  if (edits.length === 0) {
    return null;
  }

  return rootNode.commitEdits(edits);
};

export default codemod;
