import { PrismaClient } from '@prisma/client'
import { seedUsers } from './seeders/userSeeder'
import { seedSpaces } from './seeders/spaceSeeder'
import { seedTransactions } from './seeders/transactionSeeder'

const prisma = new PrismaClient()

async function main() {
  console.log('Memulai proses seeding...')

  const user = await seedUsers(prisma)
  const space = await seedSpaces(prisma, user.id)
  await seedTransactions(prisma, space.id, user.id)

  console.log('Semua seeding selesai!')
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })