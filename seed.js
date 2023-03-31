const childProcess = require("child_process");
const util = require("util");
const crypto = require("crypto");

const exec = util.promisify(childProcess.exec);

const extractPassword = (stdout) => stdout.match(/New password:\s(.+?)$/)[1];

const createAccount = async () => {
  const username = crypto.randomBytes(8).toString("hex");
  const email = crypto.randomBytes(8).toString("hex") + "@example.com";

  const { stdout } = await exec(
    `RAILS_ENV=development bin/tootctl accounts create ${username} --email=${email} --confirmed`
  );

  const password = extractPassword(stdout.trim());

  return { email, password };
};

const main = async () => {
  const [, , ...args] = process.argv;

  const count = Number(args[0]);

  if (count % 1 !== 0 || count < 0) {
    console.error("Invalid count");
    process.exit(1);
  }

  let out = "";

  for (let i = 0; i < count; i++) {
    const credentials = await createAccount();
    out += `${credentials.email}:${credentials.password}\n`;
  }

  console.log(out.trim());
  process.exit(0);
};

main();
