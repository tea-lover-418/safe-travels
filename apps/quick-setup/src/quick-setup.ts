import { program } from "commander";

/** Under construction
 *
 * Steps:
 * 1. setup database, https://www.mongodb.com/docs/atlas/cli/current/
 * 3. copy connection string and hold. Maybe write to some local file
 * 4. setup vercel, https://vercel.com/docs/cli
 * 5. setup env, including the connection string
 * 6. ask for optional env, home coords and api token (rec)
 */

program
  .version("1.0.0")
  .description("Safe Travels - Quick setup CLI")
  .action(() => {
    console.log(`This CLI is still under construction!`);
  });

program.parse(process.argv);
