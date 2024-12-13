export type TransactionType = "deposit" | "withdrawal" | "transfer";
export type TransactionStatus = "pending" | "completed" | "failed";

export interface Transaction {
  id: number;
  userId: number;
  amount: number;
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
