import { Express } from "express";
import { setupAuth } from "./auth";
import { db } from "../db";
import { transactions } from "@db/schema";
import { eq } from "drizzle-orm";

export function registerRoutes(app: Express) {
  setupAuth(app);

  // Get user transactions
  app.get("/api/transactions", async (req, res) => {
    if (!req.isAuthenticated()) {
      return res.status(401).send("Not authenticated");
    }

    try {
      const userTransactions = await db.query.transactions.findMany({
        where: eq(transactions.userId, req.user!.id),
        orderBy: (transactions, { desc }) => [desc(transactions.createdAt)],
      });
      res.json(userTransactions);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch transactions" });
    }
  });

  // Create new transaction
  app.post("/api/transactions", async (req, res) => {
    if (!req.isAuthenticated()) {
      return res.status(401).send("Not authenticated");
    }

    try {
      const [transaction] = await db
        .insert(transactions)
        .values({
          ...req.body,
          userId: req.user!.id,
          status: "completed",
        })
        .returning();
      res.json(transaction);
    } catch (error) {
      res.status(500).json({ error: "Failed to create transaction" });
    }
  });

  return app;
}
