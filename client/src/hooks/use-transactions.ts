import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import type { Transaction, TransactionSummary, TransactionFormData } from "@/types/transaction";
import { useToast } from "@/hooks/use-toast";

export function useTransactions() {
  const { data: transactions, isLoading, error } = useQuery<Transaction[]>({
    queryKey: ["/api/transactions"],
    placeholderData: [], // Provide empty array as placeholder
  });

  const queryClient = useQueryClient();
  const { toast } = useToast();

  const createTransaction = useMutation({
    mutationFn: async (data: TransactionFormData) => {
      const response = await fetch("/api/transactions", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
        credentials: "include",
      });

      if (!response.ok) {
        const text = await response.text();
        throw new Error(text || response.statusText);
      }

      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/transactions"] });
      toast({
        title: "Success",
        description: "Transaction created successfully",
      });
    },
    onError: (error: Error) => {
      toast({
        variant: "destructive",
        title: "Error",
        description: error.message,
      });
    },
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
    createTransaction: createTransaction.mutateAsync,
  };
}
