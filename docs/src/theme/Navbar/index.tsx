import React from 'react';
import type {ReactElement} from 'react';
import './styles.css';

export default function Navbar(): ReactElement {
  return (
    <nav className="navbar navbar--fixed-top custom-navbar">
      <div className="navbar__inner">
        <div className="navbar__items">
          <div className="navbar-brand">
            <a href="/docs/" className="navbar__brand">
              <span className="navbar-title">body.build</span>
              <span className="navbar-subtitle">docs</span>
            </a>
          </div>
        </div>
        <div className="navbar__items navbar__items--right">
          <a href="https://body.build" className="navbar-link">Homepage</a>
          <a href="https://body.build/app" className="navbar-link navbar-link-primary">Launch App</a>
        </div>
      </div>
    </nav>
  );
}
