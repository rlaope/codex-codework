import { readFileSync } from "node:fs";

const skillPath = new URL("../skills/codework/SKILL.md", import.meta.url);
const readmePath = new URL("../README.md", import.meta.url);
const agentMetaPath = new URL("../skills/codework/agents/openai.yaml", import.meta.url);
const installPath = new URL("../install.sh", import.meta.url);

const skill = readFileSync(skillPath, "utf8");
const readme = readFileSync(readmePath, "utf8");
const agentMeta = readFileSync(agentMetaPath, "utf8");
const install = readFileSync(installPath, "utf8");

const checks = [
  ["skill has frontmatter", /^---\n[\s\S]+?\n---\n/.test(skill)],
  ["skill name is codework", /^name: codework$/m.test(skill)],
  ["skill has description", /^description: ".+"$/m.test(skill)],
  ["skill includes ralplan gate", skill.includes("$ralplan")],
  ["skill includes implementation lanes", skill.includes("$ultragoal") && skill.includes("$ultrawork")],
  ["skill includes code review gate", skill.includes("$code-review")],
  ["skill requires HITL before merge", skill.includes("HITL merge approval") && skill.includes("Do not merge until the user gives an affirmative response")],
  ["skill includes local sync contract", skill.includes("local runnable surface")],
  ["readme documents installer path", readme.includes("skills/codework")],
  ["readme documents HITL merge approval", readme.includes("human-in-the-loop merge approval") && readme.includes("asks for HITL approval before merging")],
  ["readme documents one-line install", readme.includes("curl -fsSL https://codeload.github.com/rlaope/codex-codework/tar.gz/main")],
  ["readme links GitHub repo", readme.includes("github.com/rlaope/codex-codework")],
  ["agent metadata has default prompt", agentMeta.includes("default_prompt:") && agentMeta.includes("HITL merge approval")],
  ["installer respects CODEX_HOME", install.includes("CODEX_HOME")],
  ["installer avoids sudo", !install.includes("sudo ")],
];

const failures = checks.filter(([, passed]) => !passed);

if (failures.length > 0) {
  for (const [name] of failures) {
    console.error(`FAIL ${name}`);
  }
  process.exit(1);
}

for (const [name] of checks) {
  console.log(`ok ${name}`);
}
