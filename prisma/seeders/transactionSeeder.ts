import { PrismaClient } from '@prisma/client'

export async function seedTransactions(prisma: PrismaClient, spaceId: string, userId: string) {
  console.log('Seeding Accounts & Transactions...')
  
  // 1. Buat 2 akun: Aset (Dompet) dan Pemasukan (Gaji)
  const assetAccount = await prisma.account.create({
    data: { space_id: spaceId, name: 'Kas di Tangan', type: 'ASSET' }
  })
  const incomeAccount = await prisma.account.create({
    data: { space_id: spaceId, name: 'Pendapatan Gaji', type: 'INCOME' }
  })

  // 2. Buat Transaksi beserta Jurnal Debit & Kredit
  return await prisma.transaction.create({
    data: {
      reference_code: 'TRX-AUG-001',
      description: 'Gaji Bulan Agustus',
      transaction_date: new Date(),
      created_by: userId,
      entries: {
        create: [
          { account_id: assetAccount.id, type: 'DEBIT', amount: 5000000 },  // Kas bertambah
          { account_id: incomeAccount.id, type: 'CREDIT', amount: 5000000 } // Pemasukan bertambah
        ]
      }
    }
  })
}