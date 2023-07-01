<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">Foundry NFT ERC721</h3>

  <p align="center">
    A smart contract implementing the ERC721 standard.
    <br />
    <a href="https://github.com/achoudhury4927/foundry-adil-erc721"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/achoudhury4927/foundry-adil-erc721">View Demo</a>
    ·
    <a href="https://github.com/achoudhury4927/foundry-adil-erc721/issues">Report Bug</a>
    ·
    <a href="https://github.com/achoudhury4927/foundry-adil-erc721/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#acknowledgement">Acknowledgement</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

A smart contract created with solidity that implemented the ERC20 token standards.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

- Solidity
- Foundry

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

You will need foundry to install the packages and run tests. You can find out more here: https://book.getfoundry.sh/getting-started/installation. Make to run the makefile commands.

- foundry

  ```sh
  curl -L https://foundry.paradigm.xyz | bash
  ```

- foundryup

  ```sh
  foundryup
  ```

- make
  ```sh
  sudo apt-get install make
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/achoudhury4927/foundry-adil-erc721.git
   ```
2. Run Anvil
   ```sh
   make anvil
   ```
3. Deploy contracts on local Anvil chain
   ```sh
   make deploy
   ```
4. Run tests
   ```sh
   make test
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] ERC7211 Contract
  - [x] Storage on IPFS
- [ ] ERC7211 Contract
  - [ ] Storage on-chain
  - [ ] Tests

See the [open issues](https://github.com/achoudhury4927/foundry-adil-erc721/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENT -->

## Acknowledgement

Patrick Collins Foundry Course

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

Adil Choudhury - [@ItsAdilC](https://twitter.com/ItsAdilC) - contact@adilc.me

Project Link: [https://github.com/achoudhury4927/foundry-adil-erc721](https://github.com/achoudhury4927/foundry-adil-erc721)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/achoudhury4927/foundry-adil-erc721.svg?style=for-the-badge
[contributors-url]: https://github.com/achoudhury4927/foundry-adil-erc721/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/achoudhury4927/foundry-adil-erc721.svg?style=for-the-badge
[forks-url]: https://github.com/achoudhury4927/foundry-adil-erc721/network/members
[stars-shield]: https://img.shields.io/github/stars/achoudhury4927/foundry-adil-erc721.svg?style=for-the-badge
[stars-url]: https://github.com/achoudhury4927/foundry-adil-erc721/stargazers
[issues-shield]: https://img.shields.io/github/issues/achoudhury4927/foundry-adil-erc721.svg?style=for-the-badge
[issues-url]: https://github.com/achoudhury4927/foundry-adil-erc721/issues
[license-shield]: https://img.shields.io/github/license/achoudhury4927/foundry-adil-erc721?style=for-the-badge
[license-url]: https://github.com/achoudhury4927/foundry-adil-erc721/blob/master/LICENSE.txt
