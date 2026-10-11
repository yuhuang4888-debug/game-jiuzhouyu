import { SentientActTeamListItem } from '../../sentientAct/SentientActTeamListItem';

export class GhostWalkActTeamListItem extends SentientActTeamListItem {
    public constructor(parent?) {
        super(parent);
        this.teamActivityType = 10;
        this.teamSubType = 1;
    }
}

window['GhostWalkActTeamListItem'] = GhostWalkActTeamListItem;
