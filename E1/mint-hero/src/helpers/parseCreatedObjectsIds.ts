import { SuiObjectChange, SuiObjectChangeCreated } from "@mysten/sui/client";
import { ENV } from "../env";

interface Args {
  objectChanges: SuiObjectChange[];
}

interface Response {
  swordsIds: string[];
  heroesIds: string[];
}

/**
 * Parses the provided SuiObjectChange[].
 * Extracts the IDs of the created Heroes and Swords NFTs, filtering by objectType.
 */
export const parseCreatedObjectsIds = ({ objectChanges }: Args): Response => {
  // TODO: Implement this function
  // const createdObjects = objectChanges.filter(({type}) => type === "created") as Extract<SuiObjectChange, {type: "created"}>[];
  const createdObjects = objectChanges.filter(({type}) => type === "created") as SuiObjectChangeCreated[];
  const swords = createdObjects.filter(({ objectType }) => objectType === `${ENV.PACKAGE_ID}::blacksmith::Sword`);
  const heroes = createdObjects.filter(({ objectType }) => objectType === `${ENV.PACKAGE_ID}::hero::Hero`);

  // console.log("Created objects:", createdObjects);
  // console.log("swords:", swords);
  // console.log("heroes:", heroes);
    
  return {
    swordsIds: swords.map(({ objectId }) => objectId),
    heroesIds: heroes.map(({ objectId }) => objectId),
  };
};
