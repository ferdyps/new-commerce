import { PrismaClient } from '@prisma/client/extension';

const prisma = new PrismaClient();

async function main() {
  await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      name: 'Admin',
    },
  });
}

main()
  .catch(console.error)
  .finally(() => {
    prisma.$disconnect();
  });
