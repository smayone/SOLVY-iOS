import { useQuery } from "@tanstack/react-query";
import type { Transaction, TransactionSummary } from "@/types/transaction";

export function useTransactions() {
  const { data: transactions, isLoading, error } = useQuery<Transaction[]>({
    queryKey: ["/api/transactions"],
    placeholderData: [], // Provide empty array as placeholder
  });

  const summary: TransactionSummary = {
    totalTransactions: transactions?.length ?? 0,
    totalVolume: transactions?.reduce((sum, t) => sum + Number(t.amount), 0) ?? 0,
    avgAmount: transactions?.length 
      ? transactions.reduce((sum, t) => sum + Number(t.amount), 0) / transactions.length 
      : 0,
  };

  return {
    transactions: transactions ?? [],
    summary,
    isLoading,
    error,
  };
}
