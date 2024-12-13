export type TransactionType = "deposit" | "withdrawal" | "transfer";
export type TransactionStatus = "pending" | "completed" | "failed";

export interface Transaction {
  id: number;
  userId: number;
  amount: string | number;
  type: TransactionType;
  status: TransactionStatus;
  description?: string;
  createdAt: string;
}

export interface TransactionSummary {
  totalTransactions: number;
  totalVolume: number;
  avgAmount: number;
}

export const transactionSchema = z.object({
  amount: z.string().transform((val) => parseFloat(val)),
  type: z.enum(["deposit", "withdrawal", "transfer"]),
  description: z.string().optional(),
});

export type TransactionFormData = z.infer<typeof transactionSchema>;
