import { PrismaClient } from '@prisma/client'

export async function seedUsers(prisma: PrismaClient) {
  console.log('Seeding User...')
  return await prisma.user.create({
    data: {
      username: 'dito_nyelengin',
      email: 'dito@nyelengin.id',
      password_hash: 'hashed_password_sementara'
    }
  })
}