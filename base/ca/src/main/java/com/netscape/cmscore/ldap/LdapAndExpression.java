// --- BEGIN COPYRIGHT BLOCK ---
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 2 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
// (C) 2007 Red Hat, Inc.
// All rights reserved.
// --- END COPYRIGHT BLOCK ---
package com.netscape.cmscore.ldap;

import com.netscape.certsrv.base.SessionContext;
import com.netscape.certsrv.dbs.DBException;
import com.netscape.cmscore.request.Request;

/**
 * This class represents an expression of the form
 * <var1 op val1 AND var2 op va2>.
 *
 * Expressions are used as predicates for publishing rule selection.
 *
 * @author mzhao
 */
public class LdapAndExpression extends LdapExpression {
    private LdapExpression mExp1;
    private LdapExpression mExp2;

    public LdapAndExpression(LdapExpression exp1, LdapExpression exp2) {
        mExp1 = exp1;
        mExp2 = exp2;
    }

    @Override
    public boolean evaluate(SessionContext sc)
            throws DBException {
        // If an expression is missing we assume applicability.
        if (mExp1 == null && mExp2 == null)
            return true;
        else if (mExp1 != null && mExp2 != null)
            return mExp1.evaluate(sc) && mExp2.evaluate(sc);
        else if (mExp1 == null)
            return mExp2.evaluate(sc);
        else
            // (if mExp2 == null)
            return mExp1.evaluate(sc);
    }

    @Override
    public boolean evaluate(Request req)
            throws DBException {
        // If an expression is missing we assume applicability.
        if (mExp1 == null && mExp2 == null)
            return true;
        else if (mExp1 != null && mExp2 != null)
            return mExp1.evaluate(req) && mExp2.evaluate(req);
        else if (mExp1 == null)
            return mExp2.evaluate(req);
        else
            // (if mExp2 == null)
            return mExp1.evaluate(req);
    }

    @Override
    public String toString() {
        return mExp1.toString() + " AND " + mExp2.toString();
    }
}
