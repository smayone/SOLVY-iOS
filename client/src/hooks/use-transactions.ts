import { useQuery } from "@tanstack/react-query";
import type { Transaction, TransactionSummary } from "@/types/transaction";

export function useTransactions() {
  const { data: transactions } = useQuery<Transaction[]>({
    queryKey: ["/api/transactions"],
  });

  const summary: TransactionSummary | undefined = transactions ? {
    totalTransactions: transactions.length,
    totalVolume: transactions.reduce((sum, t) => sum + Number(t.amount), 0),
    avgAmount: transactions.reduce((sum, t) => sum + Number(t.amount), 0) / transactions.length,
  } : undefined;

  return {
    transactions,
    summary,
  };
}
