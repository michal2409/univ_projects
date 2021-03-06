

module AbsGrammar where

-- Haskell module generated by the BNF converter




newtype Ident = Ident String deriving (Eq, Ord, Show, Read)
data Program a = Program a [Stmt a]
  deriving (Eq, Ord, Show, Read)

instance Functor Program where
    fmap f x = case x of
        Program a stmts -> Program (f a) (map (fmap f) stmts)
data Block a = Block a [Stmt a]
  deriving (Eq, Ord, Show, Read)

instance Functor Block where
    fmap f x = case x of
        Block a stmts -> Block (f a) (map (fmap f) stmts)
data Stmt a
    = FnDef a (Type a) Ident [Arg a] (Block a)
    | Empty a
    | BStmt a (Block a)
    | Decl a (Type a) (Item a)
    | Ass a Ident (Expr a)
    | Print a (Expr a)
    | Ret a (Expr a)
    | VRet a
    | Cond a (Expr a) (Block a)
    | CondElse a (Expr a) (Block a) (Block a)
    | While a (Expr a) (Block a)
    | Break a
    | Continue a
    | SExp a (Expr a)
  deriving (Eq, Ord, Show, Read)

instance Functor Stmt where
    fmap f x = case x of
        FnDef a type_ ident args block -> FnDef (f a) (fmap f type_) ident (map (fmap f) args) (fmap f block)
        Empty a -> Empty (f a)
        BStmt a block -> BStmt (f a) (fmap f block)
        Decl a type_ item -> Decl (f a) (fmap f type_) (fmap f item)
        Ass a ident expr -> Ass (f a) ident (fmap f expr)
        Print a expr -> Print (f a) (fmap f expr)
        Ret a expr -> Ret (f a) (fmap f expr)
        VRet a -> VRet (f a)
        Cond a expr block -> Cond (f a) (fmap f expr) (fmap f block)
        CondElse a expr block1 block2 -> CondElse (f a) (fmap f expr) (fmap f block1) (fmap f block2)
        While a expr block -> While (f a) (fmap f expr) (fmap f block)
        Break a -> Break (f a)
        Continue a -> Continue (f a)
        SExp a expr -> SExp (f a) (fmap f expr)
data Item a = NoInit a Ident | Init a Ident (Expr a)
  deriving (Eq, Ord, Show, Read)

instance Functor Item where
    fmap f x = case x of
        NoInit a ident -> NoInit (f a) ident
        Init a ident expr -> Init (f a) ident (fmap f expr)
data Arg a = Arg a (Type a) Ident
  deriving (Eq, Ord, Show, Read)

instance Functor Arg where
    fmap f x = case x of
        Arg a type_ ident -> Arg (f a) (fmap f type_) ident
data Type a
    = TInt a
    | TStr a
    | TBool a
    | TVoid a
    | TRef a (Type a)
    | TList a (Type a)
    | TFun a (Type a) Ident [Arg a]
  deriving (Eq, Ord, Show, Read)

instance Functor Type where
    fmap f x = case x of
        TInt a -> TInt (f a)
        TStr a -> TStr (f a)
        TBool a -> TBool (f a)
        TVoid a -> TVoid (f a)
        TRef a type_ -> TRef (f a) (fmap f type_)
        TList a type_ -> TList (f a) (fmap f type_)
        TFun a type_ ident args -> TFun (f a) (fmap f type_) ident (map (fmap f) args)
data Expr a
    = EVar a Ident
    | ELitInt a Integer
    | ELitTrue a
    | ELitFalse a
    | EApp a Ident [Expr a]
    | EList a [Expr a]
    | ELen a Ident
    | EListIdx a Ident (Expr a)
    | LAppend a Ident (Expr a)
    | EString a String
    | Neg a (Expr a)
    | Not a (Expr a)
    | EMul a (Expr a) (MulOp a) (Expr a)
    | EAdd a (Expr a) (AddOp a) (Expr a)
    | ERel a (Expr a) (RelOp a) (Expr a)
    | EAnd a (Expr a) (Expr a)
    | EOr a (Expr a) (Expr a)
  deriving (Eq, Ord, Show, Read)

instance Functor Expr where
    fmap f x = case x of
        EVar a ident -> EVar (f a) ident
        ELitInt a integer -> ELitInt (f a) integer
        ELitTrue a -> ELitTrue (f a)
        ELitFalse a -> ELitFalse (f a)
        EApp a ident exprs -> EApp (f a) ident (map (fmap f) exprs)
        EList a exprs -> EList (f a) (map (fmap f) exprs)
        ELen a ident -> ELen (f a) ident
        EListIdx a ident expr -> EListIdx (f a) ident (fmap f expr)
        LAppend a ident expr -> LAppend (f a) ident (fmap f expr)
        EString a string -> EString (f a) string
        Neg a expr -> Neg (f a) (fmap f expr)
        Not a expr -> Not (f a) (fmap f expr)
        EMul a expr1 mulop expr2 -> EMul (f a) (fmap f expr1) (fmap f mulop) (fmap f expr2)
        EAdd a expr1 addop expr2 -> EAdd (f a) (fmap f expr1) (fmap f addop) (fmap f expr2)
        ERel a expr1 relop expr2 -> ERel (f a) (fmap f expr1) (fmap f relop) (fmap f expr2)
        EAnd a expr1 expr2 -> EAnd (f a) (fmap f expr1) (fmap f expr2)
        EOr a expr1 expr2 -> EOr (f a) (fmap f expr1) (fmap f expr2)
data AddOp a = Plus a | Minus a
  deriving (Eq, Ord, Show, Read)

instance Functor AddOp where
    fmap f x = case x of
        Plus a -> Plus (f a)
        Minus a -> Minus (f a)
data MulOp a = Times a | Div a | Mod a
  deriving (Eq, Ord, Show, Read)

instance Functor MulOp where
    fmap f x = case x of
        Times a -> Times (f a)
        Div a -> Div (f a)
        Mod a -> Mod (f a)
data RelOp a = LTH a | LE a | GTH a | GE a | EQU a | NE a
  deriving (Eq, Ord, Show, Read)

instance Functor RelOp where
    fmap f x = case x of
        LTH a -> LTH (f a)
        LE a -> LE (f a)
        GTH a -> GTH (f a)
        GE a -> GE (f a)
        EQU a -> EQU (f a)
        NE a -> NE (f a)
