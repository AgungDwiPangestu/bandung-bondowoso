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

const SAFE_PROVIDER_REWRITES: Record<string, string> = {
  JsonRpcProvider: "JsonRpcProvider",
  JsonRpcBatchProvider: "JsonRpcBatchProvider",
  WebSocketProvider: "WebSocketProvider",
  StaticJsonRpcProvider: "StaticJsonRpcProvider",
  FallbackProvider: "FallbackProvider",
  AlchemyProvider: "AlchemyProvider",
  InfuraProvider: "InfuraProvider",
  EtherscanProvider: "EtherscanProvider",
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
        `ethers.utils.${fromName}`,
        `ethers.utils.${fromName}`,
        `ethers.${toName}`,
      ),
    );
  }

  for (const [fromName, toName] of Object.entries(SAFE_PROVIDER_REWRITES)) {
    edits.push(
      ...replaceAllMatches(
        rootNode,
        `ethers.providers.${fromName}`,
        `ethers.providers.${fromName}`,
        `ethers.${toName}`,
      ),
    );
  }

  if (edits.length === 0) {
    return null;
  }

  return rootNode.commitEdits(edits);
};

export default codemod;
