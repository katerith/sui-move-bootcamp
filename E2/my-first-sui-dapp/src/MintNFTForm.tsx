import { Button } from "@radix-ui/themes"
import { Transaction } from "@mysten/sui/transactions";
import { useCurrentAccount, useSignAndExecuteTransaction, useSuiClient } from "@mysten/dapp-kit";
import { useQueryClient } from "@tanstack/react-query";

export const MintNFTForm = () => {  
    const suiClient = useSuiClient();
    const account = useCurrentAccount();
    const queryClient = useQueryClient();
    const { mutateAsync } = useSignAndExecuteTransaction();


    const handleMint = () => {
        if (!account?.address) {
            alert("Please connect your wallet first");
            return;
        }
        const tx = new Transaction();
        const hero = tx.moveCall({
            target: "0xc413c2e2c1ac0630f532941be972109eae5d6734e540f20109d75a59a1efea1e::hero::mint_hero",
            arguments: [],
            typeArguments: [],
        }); 
        tx.transferObjects([hero], account?.address);

        mutateAsync({ 
            transaction: tx 
        })
        .then(async (res) => {
            
            console.log('res', res)
            await suiClient.waitForTransaction({ digest: res.digest })
            queryClient.invalidateQueries({
            // queryKey: ["testnet", "ownedObjects"],
            predicate: (query) => query.queryKey[0] === "testnet" && query.queryKey[1] === "getOwnedObjects"
        })
    })
    .catch((err) => {
        console.error('Error minting NFT:', err);
        alert("Error minting NFT: " + err.message);
    });
    console.log('tx', tx);
}

    return <Button onClick={handleMint}>Mint Hero!</Button>
}