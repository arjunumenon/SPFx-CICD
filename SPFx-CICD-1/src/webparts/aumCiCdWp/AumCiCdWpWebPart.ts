import { Version } from '@microsoft/sp-core-library';
import { BaseClientSideWebPart } from '@microsoft/sp-webpart-base';

import styles from './AumCiCdWpWebPart.module.scss';

export interface IAumCiCdWpWebPartProps {
}

export default class AumCiCdWpWebPart extends BaseClientSideWebPart<IAumCiCdWpWebPartProps> {

  protected onInit(): Promise<void> {
    return super.onInit();
  }

  public render(): void {
    this.domElement.innerHTML = `<div class="${ styles.aumCiCdWp }">Welcome to the Awesome SPFx World. Magic starts here. Howdy People</div>`;
  }

  protected get dataVersion(): Version {
    return Version.parse('1.0');
  }
}
